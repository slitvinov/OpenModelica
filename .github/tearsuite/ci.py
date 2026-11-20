"""ci.py OMC: for each cases/<name>.mo with the exact solution in cases/<name>.json, build with each tearing and
run; print OK (values match the exact solution), WRONG <max rel. error> (reported success) or FAIL."""
import sys, os, json, csv, subprocess, glob
OMC = os.path.abspath(sys.argv[1])
V = [("cellier", "--tearingMethod=cellier", ["", "-nls=hybrid", "-nls=newton", "-nls=kinsol"]),
     ("omcTearing", "--tearingMethod=omcTearing", [""]), ("minimalTearing", "--tearingMethod=minimalTearing", [""]),
     ("noTearing", "--tearingMethod=noTearing", [""]), ("newBackend", "--newBackend", [""])]
cols = [v + (" " + s if s else "") for v, _, ss in V for s in ss]
print("| model | " + " | ".join(cols) + " |"); print("|---" * (len(cols) + 1) + "|")
for mo in sorted(glob.glob("cases/*.mo")):
    name = os.path.basename(mo)[:-3]; ex = json.load(open(mo[:-3] + ".json")); d = "out/" + name
    os.makedirs(d, exist_ok=True); cells = []
    for v, fl, ss in V:
        open(d + "/a.mos", "w").write('setCommandLineOptions("%s"); loadFile("../../%s"); buildModel(%s, stopTime=1, numberOfIntervals=1, outputFormat="csv", fileNamePrefix="%s"); getErrorString();\n' % (fl, mo, name, v))
        subprocess.run([OMC, "a.mos"], cwd=d, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for s in ss:
            if not os.path.exists("%s/%s" % (d, v)): cells.append("no build"); continue
            if os.path.exists("%s/%s_res.csv" % (d, v)): os.remove("%s/%s_res.csv" % (d, v))
            p = subprocess.run(["./" + v] + s.split(), cwd=d, capture_output=True, text=True, timeout=600)
            try:
                rows = list(csv.reader(open("%s/%s_res.csv" % (d, v)))); h = rows[0]
                e = max((lambda d: d if d == d else float("inf"))(abs(float(r[h.index(k)]) - x) / (abs(x) + 1e-3)) for r in rows[1:] for k, x in ex.items())  # NaN counts as not OK
            except Exception: e = None
            cells.append("FAIL" if p.returncode or e is None else ("OK" if e < 1e-4 else "WRONG %.0e" % e))
    print("| %s | %s |" % (name, " | ".join(cells)), flush=True)
