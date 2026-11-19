"""init.py NAME NRAND: steady-state initialization of a heat network at parameter points, omc default backend and --newBackend.
Points: NAME.pts (the model's own parameters as point 'default', listed points, then NRAND uniform random points in RANGES).
For every point: the steady-state model (der_T(fixed = true)) with each backend, and a relaxation run (old backend) of the same
network with fixed positive start temperatures and inputs frozen at their t = 0 values (model <cls>R), simulated to t = 1e8 s.
Writes out/NAME.tsv."""
import sys, os, re, csv, subprocess, random
OMC = os.path.abspath("om/bin/omc")
name, nrand = sys.argv[1], int(sys.argv[2])
HERE = os.path.dirname(os.path.abspath(__file__))
RANGES = {"ZH7065": {"rad1.Gr": (0.1, 4), "Q1.Q_flow": (-50, 20), "G2.G": (0.05, 2), "G3.G": (0.05, 2)},
          "ZB7007": {"amb1.T": (250, 330), "rad1.Gr": (0.05, 2), "G3.G": (1, 50)},
          "ZB7060": {"amb1.T": (250, 330), "rad1.Gr": (0.05, 2), "rad3.Gr": (0.1, 3), "Q2.Q_flow": (-100, 50), "Q3.Q_flow": (-100, 200), "G1.G": (0.02, 0.5)}}
lines = open("%s/%s.pts" % (HERE, name)).read().split()
cls, pn = lines[0], lines[1].split(",")
pts = [("default", None)] + [("p%d" % i, [float(v) for v in l.split(",")]) for i, l in enumerate(lines[2:])]
rnd = random.Random(1)
for i in range(nrand):
    pts.append(("r%d" % i, [rnd.uniform(*RANGES[name][p]) for p in pn]))
os.makedirs("out/" + name, exist_ok=True)
wd = os.path.abspath("out/" + name)
pre = 'installPackage(Modelica, "4.1.0+maint.om", exactMatch=true); loadModel(Modelica, {"4.1.0"}); getErrorString();\n'
if cls == "Zbheat7007s":
    pre = 'installPackage(Buildings, "13.0.1", exactMatch=true); loadModel(Buildings, {"13.0.1"}); getErrorString();\n'
mos = pre + 'loadFile("%s/%s.mo"); loadFile("%s/%sR.mo"); print(getErrorString());\n' % (HERE, cls, HERE, cls)
mos += 'r := buildModel(%s, stopTime = 1e-3, numberOfIntervals = 2, outputFormat = "csv", fileNamePrefix = "old"); print("build old: " + r[1] + "\\n" + getErrorString());\n' % cls
mos += 'r := buildModel(%sR, stopTime = 1e8, numberOfIntervals = 100, outputFormat = "csv", fileNamePrefix = "relax"); print("build relax: " + r[1] + "\\n" + getErrorString());\n' % cls
mos += 'setCommandLineOptions("--newBackend");\n'
mos += 'r := buildModel(%s, stopTime = 1e-3, numberOfIntervals = 2, outputFormat = "csv", fileNamePrefix = "new"); print("build new: " + r[1] + "\\n" + getErrorString());\n' % cls
open(wd + "/b.mos", "w").write(mos)
print(subprocess.run([OMC, "b.mos"], cwd=wd, capture_output=True, text=True).stdout)

def rd(f):
    try:
        rows = list(csv.reader(open(f)))
    except Exception:
        return None
    if len(rows) < 2: return None
    h = rows[0]
    return {k: (float(rows[1][j]), float(rows[-1][j])) for j, k in enumerate(h) if rows[1][j] not in ("",)}

def run(exe, tag, ov):
    o = "%s/%s_%s.csv" % (wd, exe, tag)
    args = ["./" + exe, "-r=" + o] + (["-override=" + ov] if ov else [])
    try:
        p = subprocess.run(args, cwd=wd, capture_output=True, text=True, timeout=300)
        log = p.stdout + p.stderr
    except subprocess.TimeoutExpired:
        return None, "timeout"
    d = rd(o) if os.path.exists(o) else None
    if os.path.exists(o): os.remove(o)
    return d, log

tv = lambda k: re.search(r"\.T$", k) and not re.match(r"T[sc]\d+\.T$", k) and not k.startswith("der(")
caps = None
out = open("out/%s.tsv" % name, "w")
out.write("model\tpoint\t%s\tbackend\tinit_ok\tmin_warning\tTmin\tTmin_var\tmax_C_derT_t0\trelax_Tmin\trelax_max_C_derT_end\tmax_dT_to_relax\tparams_applied\n" % "\t".join(pn))
for tag, p in pts:
    ov = ",".join("%s=%r" % (k, v) for k, v in zip(pn, p)) if p else ""
    rel, rlog = run("relax", tag, ov)
    for b in ("old", "new"):
        d, log = run(b, tag, ov)
        ok = d is not None and "initialization finished successfully" in log and "Simulation execution failed" not in log
        warn = "violating min constraint" in log
        if d is None:
            out.write("\t".join([cls, tag] + ["%.6g" % v for v in (p or [float("nan")] * len(pn))] + [b, "0", str(int(warn))] + ["nan"] * 6 + ["-"]) + "\n")
            print(tag, b, "FAIL", log[-300:].replace("\n", " | ")); continue
        Ts = {k: v[0] for k, v in d.items() if tv(k)}
        kmin = min(Ts, key=Ts.get)
        cap = sorted(k[4:-3] for k in d if re.match(r"der\(C\d+\.T\)$", k))
        Cval = {}
        for c in cap:
            m = re.search(r"%s\(C=([0-9.e+-]+)" % c, open("%s/%s.mo" % (HERE, cls)).read())
            Cval[c] = float(m.group(1))
        res0 = max(abs(Cval[c] * d["der(%s.T)" % c][0]) for c in cap)
        if rel:
            rTs = {k: v[1] for k, v in rel.items() if tv(k)}
            rmin = min(rTs.values())
            rres = max(abs(Cval[c] * rel["der(%s.T)" % c][1]) for c in cap)
            dT = max(abs(Ts[k] - rTs[k]) for k in Ts if k in rTs)
        else:
            rmin = rres = dT = float("nan")
        # parameters applied: check the defining relation of each varied parameter in the result
        chk = []
        for k, v in zip(pn, p or []):
            c, a = k.rsplit(".", 1)
            if a == "G": got = d[c + ".Q_flow"][0] / d[c + ".dT"][0] if abs(d[c + ".dT"][0]) > 1e-9 else v
            elif a == "Gr": got = d[c + ".Q_flow"][0] / (5.670374419e-8 * (d[c + ".port_a.T"][0] ** 4 - d[c + ".port_b.T"][0] ** 4))
            elif a == "Q_flow": got = -d[c + ".port.Q_flow"][0]
            elif a == "T": got = d[c + ".port.T"][0]
            chk.append(abs(got - v) <= 1e-6 * max(1, abs(v)))
        pa = "yes" if all(chk) else "NO"
        out.write("\t".join([cls, tag] + ["%.6g" % v for v in (p or [float("nan")] * len(pn))] +
                            [b, str(int(ok)), str(int(warn)), "%.6g" % Ts[kmin], kmin, "%.3g" % res0, "%.6g" % rmin, "%.3g" % rres, "%.3g" % dT, pa]) + "\n")
        out.flush()
        print(tag, b, "ok" if ok else "fail", "warn" if warn else "", "Tmin %.4g (%s) res %.2g | relax Tmin %.4g res %.2g dT %.3g params %s" % (Ts[kmin], kmin, res0, rmin, rres, dT, pa))
