"""ana.py CASEDIR... > ana.tsv: for each variant (cel omc min no nb) and each non-linear torn system in
<variant>_info.json: torn Jacobian (Schur complement, by complex step through the inner equations) at the
exact solution, its condition number, max |d inner / d iteration var|, and the inner values at the start point."""
import sys, os, re, json, csv, cmath, math
import numpy as np
FN = {k: getattr(cmath, k) for k in ("sinh", "cosh", "tanh", "exp", "log", "sqrt", "sin", "cos", "atan", "tan", "asinh")}
NAME = re.compile(r"(?<![\w.$])([A-Za-z_$][\w$]*(?:\.[A-Za-z_$][\w$]*)*(?:\[\d+(?:,\d+)*\])?)")
san = lambda n: "v_" + re.sub(r"\W", "_", n)
def tr(s):
    s = re.sub(r"der\(([^()]*)\)", lambda m: "der_" + m.group(1), s)
    s = NAME.sub(lambda m: m.group(1) if m.group(1) in FN else san(m.group(1)), s)
    return compile(s.replace("^", "**"), "<e>", "eval")
def values(d, ex):
    v = {}
    for f in ("no.csv", "no_res.csv", "omc_res.csv", "min_res.csv", "nb_res.csv", "cel_res.csv"):
        p = os.path.join(d, f)
        if os.path.exists(p):
            rows = list(csv.reader(open(p)))
            if len(rows) > 1:
                for k, x in zip(rows[0], rows[1]):
                    try: v.setdefault(san(k.replace("der(", "der_").replace(")", "")), float(x))
                    except ValueError: pass
    mo = open(os.path.join(d, "M.mo")).read()
    for n, arr in re.findall(r"parameter Real (\w+)\[\d+\] = \{([^}]*)\}", mo):
        for i, x in enumerate(arr.split(",")): v[san("%s[%d]" % (n, i + 1))] = float(x)
    for n, x in re.findall(r"parameter Real (\w+) = ([-\d.eE+]+);", mo): v[san(n)] = float(x)
    for k, x in ex.items(): v[san(k)] = x; v.setdefault(san("$DER." + k), 0.0)  # steady-state references
    return v
def chain(inner, resid, it, base, x, k=None, h=1e-20):
    env = dict(base); env.update(FN)
    for j, n in enumerate(it): env[n] = complex(x[j], h if j == k else 0)
    for n, c in inner: env[n] = eval(c, {"__builtins__": {}}, env)
    return env, [eval(c, {"__builtins__": {}}, env) for c in resid]
def analyse(d, v, ex, st):
    p = "%s/%s_info.json" % (d, v)
    if not os.path.exists(p): return []
    info = json.load(open(p)); E = {e["eqIndex"]: e for e in info["equations"]}
    base = values(d, ex); out = []
    for e in info["equations"]:
        if e.get("tag") not in ("tornsystem", "system") or e.get("display") != "non-linear": continue
        try:
            inner, resid = [], []
            for i in e["equation"][0]:
                q = E[i]
                if q["tag"] == "torn": inner.append((san(q["defines"][0]), tr(q["equation"][0])))
                elif q["tag"] == "residual": resid.append(tr(q["equation"][0]))
                else: raise ValueError("tag " + q["tag"])
            it = [san(n) for n in e["defines"]]
            x = np.array([base.get(n, 0.0) for n in it], float)
            for _ in range(30):  # polish only iteration vars without exact value (cse/$FUN); exact ones are a solution
                env, r = chain(inner, resid, it, base, x)
                r = np.array([z.real for z in r]); J = np.zeros((len(resid), len(it)))
                for k in range(len(it)): J[:, k] = [z.imag / 1e-20 for z in chain(inner, resid, it, base, x, k)[1]]
                if np.max(np.abs(r), initial=0) < 1e-13: break
                x = x - np.linalg.lstsq(J, r, rcond=None)[0]
            res0 = float(np.max(np.abs(r), initial=0))
            amp = 0.0; innerm = [n for n, _ in inner if not n.startswith("v__")]
            for k in range(len(it)):
                env = chain(inner, resid, it, base, x, k)[0]
                amp = max([amp] + [abs(env[n].imag / 1e-20) for n in innerm])
            cond = float(np.linalg.cond(J)) if J.size else 1.0
            # start point
            sv = [st.get(n_, 0.0) for n_ in e["defines"]]
            try:
                env, r0 = chain(inner, resid, it, base, sv, h=0)
                smax = max([abs(env[n]) for n in innerm] + [abs(z) for z in r0])
                smax = smax if math.isfinite(smax) else float("inf")
            except (OverflowError, ZeroDivisionError, ValueError): smax = float("inf")
            out.append(dict(sys=e["eqIndex"], section=e.get("section", "?"), niter=len(it), nunk=e.get("unknowns", len(it)),
                            cond=cond, amp=amp, res0=res0, startmax=smax, iters=" ".join(e["defines"])))
        except (OverflowError, ZeroDivisionError, np.linalg.LinAlgError):  # torn map not evaluable at the exact solution
            out.append(dict(sys=e["eqIndex"], section=e.get("section", "?"), niter=len(e["defines"]), nunk=e.get("unknowns"),
                            cond=float("inf"), amp=float("inf"), res0=float("inf"), startmax=float("inf"), iters=" ".join(e["defines"])))
        except Exception as x:
            out.append(dict(sys=e["eqIndex"], section=e.get("section", "?"), niter=len(e.get("defines", [])), nunk=e.get("unknowns"), error=(type(x).__name__ + " " + str(x))[:80]))
    return out
K = ["case", "family", "n", "k1", "k2", "k3", "seed", "variant", "sys", "section", "niter", "nunk", "cond", "amp", "res0", "startmax", "out", "iters"]
print("\t".join(K))
for d in sys.argv[1:]:
    if not os.path.exists(d + "/res.json"): continue
    meta = json.load(open(d + "/meta.json")); p = meta["params"]; res = json.load(open(d + "/res.json"))
    ks = [p.get(k, "") for k in (("kappa", "sigma", "phi") if p["family"] == "mono" else ("r", "c", "") if p["family"] == "heat" else ("", "", ""))]
    for v in ("cel", "omc", "min", "no", "nb"):
        for a in analyse(d, v, meta["exact"], meta.get("start", {})) or [dict()]:
            row = dict(case=os.path.basename(d), family=p["family"], n=p["n"], k1=ks[0], k2=ks[1], k3=ks[2], seed=p.get("seed", ""), variant=v, out=res[v]["out"])
            row.update(a)
            if "error" in a: row["iters"] = "ERR " + a["error"]
            print("\t".join(str(row.get(k, "")) for k in K))
