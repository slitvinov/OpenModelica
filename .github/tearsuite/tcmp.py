"""tcmp.py LABEL=RES.tsv...: OK counts of tsuite.py runs side by side, the cases a run changes against the first
one, and the number of systems not torn ('Tearing is skipped' notifications)."""
import sys, collections
rd = lambda fn: (lambda L: [dict(zip(L[0], r)) for r in L[1:]])([l.rstrip("\n").split("\t") for l in open(fn)])
runs = [a.split("=", 1) for a in sys.argv[1:]]
R = {lab: {(r["case"], r["run"]): r for r in rd(fn)} for lab, fn in runs}
fam = {r["case"]: r["family"] for lab in R for (c, _), r in R[lab].items()}
F = ("mono", "heat")
print("OK = every variable within 1e-4 relative of the exact solution; WRONG = success reported, values differ;")
print("FAIL = the simulation fails or times out; CFAIL = no executable. skipped = systems the check did not tear.\n")
print("| tearing | run | mono OK | WRONG | FAIL | CFAIL | heat OK | WRONG | FAIL | CFAIL | skipped |"); print("|---" * 11 + "|")
for m, ml in (("cel", "cellier (default)"), ("omc", "omcTearing")):
    for lab, _ in runs:
        row = []
        for f in F:
            n = collections.Counter(r["out"] for (c, mm), r in R[lab].items() if mm == m and fam[c] == f)
            row += [n["OK"], n["WRONG"], n["FAIL"], n["CFAIL"]]
        sk = sum(int(r.get("skipped") or 0) for (c, mm), r in R[lab].items() if mm == m)
        print("| %s | %s | %s | %d |" % (ml, lab, " | ".join(map(str, row)), sk))
b = runs[0][0]
print("\nChanges against %s (cases):\n" % b)
print("| tearing | run | not OK -> OK | OK -> not OK | tearing changed |"); print("|---|---|---|---|---|")
for m, ml in (("cel", "cellier"), ("omc", "omcTearing")):
    for lab, _ in runs[1:]:
        ks = [k for k in R[lab] if k[1] == m and k in R[b]]
        up = [k[0] for k in ks if R[b][k]["out"] != "OK" and R[lab][k]["out"] == "OK"]
        dn = [k[0] for k in ks if R[b][k]["out"] == "OK" and R[lab][k]["out"] != "OK"]
        ch = sum(R[b][k].get("tears") != R[lab][k].get("tears") for k in ks)
        print("| %s | %s | %d | %d%s | %d |" % (ml, lab, len(up), len(dn), (" (" + ", ".join(sorted(dn)[:6]) + ")") if dn else "", ch))
