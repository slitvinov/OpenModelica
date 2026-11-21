"""pred.py OMC: the 480 cases of gen.py, each built with the default tearing and -d=tearingCost, run and compared with
the exact solution (1e-4 relative). amp.awk reads omc's output and gives the largest amplification of a torn
non-linear system. Prints the cases and the number solved per amplification band."""
import sys, os, json, csv, subprocess, collections, concurrent.futures as cf
H = os.path.dirname(os.path.abspath(__file__)); OMC = os.path.abspath(sys.argv[1]); G = os.path.abspath("gen")
subprocess.run([sys.executable, H + "/gen.py", G], check=True, stdout=subprocess.DEVNULL)
def case(c):
    d = G + "/" + c; ex = json.load(open(d + "/meta.json"))["exact"]
    open(d + "/s.mos", "w").write('loadFile("M.mo"); setCommandLineOptions("-d=tearingCost"); buildModel(M, stopTime=1, numberOfIntervals=1, outputFormat="csv");\n')
    subprocess.run("cd %s && timeout 900 %s s.mos > omc.log 2>&1 && timeout 120 ./M > run.log 2>&1" % (d, OMC), shell=True)
    amp = float(subprocess.run(["awk", "-f", H + "/amp.awk", d + "/omc.log"], capture_output=True, text=True).stdout)
    try:
        r = list(csv.reader(open(d + "/M_res.csv"))); h = r[0]
        ok = all(abs(float(r[1][h.index(k)]) - v) <= 1e-4 * (abs(v) + 1e-3) for k, v in ex.items())
    except Exception: ok = False
    return amp, ok
cases = sorted(os.listdir(G))
with cf.ThreadPoolExecutor(os.cpu_count()) as ex: res = list(ex.map(case, cases))
B = [(0, 1e2), (1e2, 1e5), (1e5, 1e8), (1e8, float("inf"))]
print("| amplification (omc -d=tearingCost) | cases | solved |\n|---|---|---|")
for lo, hi in B:
    s = [ok for a, ok in res if lo <= a < hi or (hi == B[-1][1] and a >= lo)]
    print("| %s | %d | %d |" % ("< 1e2" if lo == 0 else "> 1e8" if hi == float("inf") else "%.0e .. %.0e" % (lo, hi), len(s), sum(s)))
