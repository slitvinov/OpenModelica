"""tables.py RES.tsv ANA.tsv: the tables of the generated suite from the merged output of suite.py."""
import sys, collections
rd = lambda fn: (lambda L: [dict(zip(L[0], r)) for r in L[1:]])([l.rstrip("\n").split("\t") for l in open(fn)])
R = collections.defaultdict(dict); fam = {}
for r in rd(sys.argv[1]): R[r["case"]][r["run"]] = r["out"]; fam[r["case"]] = r["family"]
F = ("mono", "heat")
cs = {f: sorted(c for c in R if fam[c] == f) for f in F}
print("## Generated cases: %d algebraic (mono), %d heat\n" % (len(cs["mono"]), len(cs["heat"])))
print("OK = every variable within 1e-4 relative of the exact solution; WRONG = success reported, values differ;")
print("FAIL = the simulation fails or times out; CFAIL = no executable.\n")
print("| run | mono OK | WRONG | FAIL | CFAIL | heat OK | WRONG | FAIL | CFAIL |"); print("|---" * 9 + "|")
for m, lab in (("cel", "cellier (default)"), ("cel.hybrid", "cellier -nls=hybrid"), ("cel.newton", "cellier -nls=newton"),
               ("cel.kinsol", "cellier -nls=kinsol"), ("omc", "omcTearing"), ("min", "minimalTearing"), ("no", "noTearing"), ("nb", "--newBackend")):
    row = []
    for f in F:
        n = collections.Counter(R[c][m] for c in cs[f]); row += [n["OK"], n["WRONG"], n["FAIL"], n["CFAIL"]]
    print("| %s | %s |" % (lab, " | ".join(map(str, row))))
bad = [c for c in R if R[c]["cel"] != "OK"]
resc = {m: sum(R[c][m] == "OK" for c in bad) for m in ("cel.hybrid", "cel.newton", "cel.kinsol")}
print("\ncellier not OK: %d cases; OK with -nls=hybrid %d, newton %d, kinsol %d; with any of them: %d" % (
    len(bad), resc["cel.hybrid"], resc["cel.newton"], resc["cel.kinsol"], sum(any(R[c][m] == "OK" for m in resc) for c in bad)))
near = [c for c in R if "cel.near" in R[c]]
print("cellier not OK, algebraic, start values = exact + 0.01: %d cases, still not OK: %d" % (len(near), sum(R[c]["cel.near"] != "OK" for c in near)))
# max |d torn var / d iteration var| of the largest initial non-linear system per case and tearing (ana.py)
amp = {}
for r in rd(sys.argv[2]):
    if r.get("section") != "initial" or r.get("nunk") in ("", "None", None): continue
    k = (r["case"], r["variant"])
    if k not in amp or int(r["nunk"]) > amp[k][0]: amp[k] = (int(r["nunk"]), float(r["amp"]) if r.get("amp") else None)
B = [0, 1e2, 1e4, 1e6, 1e8, 1e12, float("inf")]
print("\n## max |d torn var / d iteration var| at the exact solution (largest initial system; cellier, omcTearing, --newBackend)\n")
print("| amplification | systems | OK | not OK |"); print("|---|---|---|---|")
tot = collections.Counter()
for lo, hi in zip(B[:-1], B[1:]):
    ok = no = 0
    for (c, v), (_, a) in amp.items():
        if v in ("cel", "omc", "nb") and c in R and a is not None and (lo <= a < hi or (hi == B[-1] and a == hi)):
            if R[c][v] == "OK": ok += 1
            else: no += 1
    print("| %.0e .. %.0e | %d | %d | %d |" % (lo, hi, ok + no, ok, no))
    if hi <= 1e2: tot["lo"] += ok + no; tot["lo_ok"] += ok
    if lo >= 1e8: tot["hi"] += ok + no; tot["hi_ok"] += ok
print("\n< 1e2: %d systems, %d solved; > 1e8: %d systems, %d solved" % (tot["lo"], tot["lo_ok"], tot["hi"], tot["hi_ok"]))
