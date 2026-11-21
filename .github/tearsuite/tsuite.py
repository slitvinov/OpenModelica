"""tsuite.py OMC OUT "FLAGS" [SHARD NSHARDS]: the 480 cases of gen.py (generated in OUT/gen), built with cellier and
omcTearing plus FLAGS (e.g. --tearingMaxAmplification=1e5), run and compared with the exact solution (as suite.py).
Writes OUT/res-SHARD.tsv: case family n run out err skipped (number of 'Tearing is skipped' notifications) tears
(iteration variables of the non-linear systems in the initial section, from <run>_info.json)."""
import sys, os, re, json, subprocess, concurrent.futures as cf
HERE = os.path.dirname(os.path.abspath(__file__))
sys.argv += [""] * 3
OMC, OUT, FL = os.path.abspath(sys.argv[1]), os.path.abspath(sys.argv[2]), sys.argv[3]
SHARD, NSH = int(sys.argv[4] or 0), int(sys.argv[5] or 1)
sys.path.insert(0, HERE); from suite_err import err
VARS = [("cel", "--tearingMethod=cellier " + FL), ("omc", "--tearingMethod=omcTearing " + FL)]
def build(d, M):
    s = 'setCommandLineOptions("-n=1"); loadFile("M.mo"); getErrorString();\n'
    for v, fl in VARS:
        s += 'setCommandLineOptions("%s"); buildModel(%s, stopTime=1, numberOfIntervals=1, outputFormat="csv", fileNamePrefix="%s"); writeFile("%s.err", getErrorString());\n' % (fl.strip(), M, v, v)
    open(d + "/a.mos", "w").write(s)
    subprocess.run("cd %s && timeout -s KILL 900 %s a.mos > omc.log 2>&1" % (d, OMC), shell=True)
def tears(d, v):
    try: info = json.load(open("%s/%s_info.json" % (d, v)))
    except Exception: return "-"
    return ",".join(str(len(e["defines"])) + "/" + str(e.get("unknowns", "?")) for e in info["equations"]
                    if e.get("section") == "initial" and e.get("tag") in ("tornsystem", "system") and e.get("display") == "non-linear") or "0"
def case(d):
    meta = json.load(open(d + "/meta.json")); ex = meta["exact"]
    build(d, meta.get("model", "M")); res = {}
    for v, _ in VARS:
        sk = open("%s/%s.err" % (d, v)).read().count("Tearing is skipped") if os.path.exists("%s/%s.err" % (d, v)) else 0
        if not os.path.exists("%s/%s" % (d, v)): res[v] = dict(out="CFAIL", err=None, skipped=sk, tears=tears(d, v)); continue
        p = subprocess.run("cd %s && rm -f %s_res.csv && timeout -s KILL 120 ./%s > %s.log 2>&1" % (d, v, v, v), shell=True)
        e = err("%s/%s_res.csv" % (d, v), ex)
        res[v] = dict(out="FAIL" if (p.returncode != 0 or e is None) else ("OK" if e < 1e-4 else "WRONG"), err=e, skipped=sk, tears=tears(d, v))
    subprocess.run("cd %s && rm -f *.c *.o *.h *.makefile *.libs *.bin *_init.xml *_JacA* cel omc" % d, shell=True)
    json.dump(res, open(d + "/res.json", "w"))
    return d, meta["params"], res
G = OUT + "/gen"
if not os.path.isdir(G): subprocess.run([sys.executable, HERE + "/gen.py", G], check=True, stdout=subprocess.DEVNULL)
cases = sorted(os.listdir(G))
if os.environ.get("CASES"): cases = [c for c in cases if re.search(os.environ["CASES"], c)]
mine = [G + "/" + c for i, c in enumerate(cases) if i % NSH == SHARD]
P = int(os.environ.get("P", os.cpu_count()))
print("omc %s flags '%s': %d cases, %d threads" % (OMC, FL, len(mine), P), flush=True)
with open("%s/res-%d.tsv" % (OUT, SHARD), "w") as f:
    f.write("case\tfamily\tn\trun\tout\terr\tskipped\ttears\n")
    with cf.ThreadPoolExecutor(P) as ex:
        for d, p, res in ex.map(case, mine):
            for name, r in res.items():
                f.write("%s\t%s\t%d\t%s\t%s\t%s\t%d\t%s\n" % (os.path.basename(d), p["family"], p["n"], name, r["out"],
                        "" if r["err"] is None else "%.3g" % r["err"], r["skipped"], r["tears"]))
            f.flush()
