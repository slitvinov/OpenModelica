"""suite.py OMC SHARD NSHARDS OUT: generate the 480 cases of gen.py in OUT/gen, take every NSHARDS-th case
starting at SHARD, build each with cellier, omcTearing, minimalTearing, noTearing and --newBackend, run
(cellier also with -nls=hybrid/newton/kinsol), compare with the exact solution. An algebraic case that
cellier does not solve is built again with the start values 0.01 from the solution (cel.near).
Writes OUT/res-SHARD.tsv (case, family, n, run, out, err) and OUT/ana-SHARD.tsv (ana.py on the cases).
Timeouts: 900 s per omc session (all builds of a case), 120 s per simulation run."""
import sys, os, re, json, csv, subprocess, concurrent.futures as cf
HERE = os.path.dirname(os.path.abspath(__file__))
OMC, SHARD, NSH, OUT = os.path.abspath(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), os.path.abspath(sys.argv[4])
VARS = [("cel", "--tearingMethod=cellier"), ("omc", "--tearingMethod=omcTearing"), ("min", "--tearingMethod=minimalTearing"),
        ("no", "--tearingMethod=noTearing"), ("nb", "--newBackend --tearingMethod=cellier")]
RUNS = [("cel", ""), ("cel.hybrid", "-nls=hybrid"), ("cel.newton", "-nls=newton"), ("cel.kinsol", "-nls=kinsol"),
        ("omc", ""), ("min", ""), ("no", ""), ("nb", "")]
def err(fn, ex):
    try: rows = list(csv.reader(open(fn)))
    except Exception: return None
    if len(rows) < 2: return None
    h = rows[0]; e = 0.0
    if any(k not in h for k in ex): return None   # a missing solution variable is FAIL
    for r in rows[1:]:
        for k, v in ex.items():
            if k in h:
                try: x = float(r[h.index(k)])
                except ValueError: return float("inf")
                except IndexError: return None   # a cut csv row
                d = abs(x - v) / (abs(v) + 1e-3)
                e = max(e, d if d == d else float("inf"))
    return e
def build(d, M, vars_):
    s = 'setCommandLineOptions("-n=1"); loadFile("M.mo"); getErrorString();\n'
    for v, fl in vars_:
        s += 'setCommandLineOptions("%s"); buildModel(%s, stopTime=1, numberOfIntervals=1, outputFormat="csv", fileNamePrefix="%s"); writeFile("%s.err", getErrorString());\n' % (fl, M, v, v)
    open(d + "/a.mos", "w").write(s)
    subprocess.run("cd %s && timeout -s KILL 900 %s a.mos > omc.log 2>&1" % (d, OMC), shell=True)
def run(d, ex, runs):
    res = {}
    for name, fl in runs:
        v = name.split(".")[0]
        if not os.path.exists("%s/%s" % (d, v)): res[name] = dict(out="CFAIL", err=None); continue
        if os.path.exists("%s/%s_res.csv" % (d, v)): os.remove("%s/%s_res.csv" % (d, v))
        p = subprocess.run("cd %s && timeout -s KILL 120 ./%s %s > %s.log 2>&1" % (d, v, fl, name), shell=True)
        e = err("%s/%s_res.csv" % (d, v), ex)
        res[name] = dict(out="FAIL" if (p.returncode != 0 or e is None) else ("OK" if e < 1e-4 else "WRONG"), err=e, rc=p.returncode)
        if os.path.exists("%s/%s_res.csv" % (d, v)): os.replace("%s/%s_res.csv" % (d, v), "%s/%s_res.csv" % (d, name))
    return res
def clean(d):
    subprocess.run("cd %s && rm -f *.c *.o *.h *.makefile *.libs *.bin *_init.xml *_JacA* cel omc min no nb" % d, shell=True)
def case(d):
    meta = json.load(open(d + "/meta.json")); ex = meta["exact"]; M = meta.get("model", "M")
    build(d, M, VARS); res = run(d, ex, RUNS); clean(d)
    if meta["params"]["family"] == "mono" and res["cel"]["out"] != "OK":  # start = exact + 0.01
        n = d + "/near"; os.makedirs(n, exist_ok=True)
        st = {k: round(x + 0.01, 6) for k, x in ex.items()}
        mo = re.sub(r"Real (x\d+);", lambda g: "Real %s(start = %g);" % (g.group(1), st[g.group(1)]), open(d + "/M.mo").read())
        open(n + "/M.mo", "w").write(mo)
        build(n, M, VARS[:1]); res["cel.near"] = run(n, ex, RUNS[:1])["cel"]; clean(n)
    json.dump(res, open(d + "/res.json", "w"))
    return d, meta["params"], res
G = OUT + "/gen"
subprocess.run([sys.executable, HERE + "/gen.py", G], check=True, stdout=subprocess.DEVNULL)
cases = sorted(os.listdir(G))
if os.environ.get("CASES"): cases = [c for c in cases if re.search(os.environ["CASES"], c)]
mine = [G + "/" + c for i, c in enumerate(cases) if i % NSH == SHARD]
P = int(os.environ.get("P", os.cpu_count()))
print("shard %d/%d: %d cases, %d threads" % (SHARD, NSH, len(mine), P), flush=True)
with open("%s/res-%d.tsv" % (OUT, SHARD), "w") as f:
    f.write("case\tfamily\tn\trun\tout\terr\n")
    with cf.ThreadPoolExecutor(P) as ex:
        for d, p, res in ex.map(case, mine):
            for name, r in res.items():
                f.write("%s\t%s\t%d\t%s\t%s\t%s\n" % (os.path.basename(d), p["family"], p["n"], name, r["out"], "" if r["err"] is None else "%.3g" % r["err"]))
            f.flush()
            print(os.path.basename(d), " ".join("%s=%s" % (k, r["out"]) for k, r in res.items()), flush=True)
with open("%s/ana-%d.tsv" % (OUT, SHARD), "w") as f:
    subprocess.run([sys.executable, HERE + "/ana.py"] + mine, stdout=f, check=True)
