"""run.py compl SHARD NSHARDS | run.py lib LIB SHARD NSHARDS
Runs omc (./om/bin/omc) with the default backend (old) and with --newBackend, one omc process per run,
writes out/<tag>.tsv: name shouldPass chapter backend status verdict secs message, and out/logs/<backend>/<name>.txt."""
import sys, os, re, subprocess, time, shutil, tempfile, concurrent.futures as cf
OMC = os.path.abspath("om/bin/omc")
HERE = os.path.dirname(os.path.abspath(__file__))
os.makedirs("out/logs/old", exist_ok=True); os.makedirs("out/logs/new", exist_ok=True)

def classify(o):
    if "@@RES=" not in o:
        return "timeout", "no result (killed after timeout)"
    rf = o.split("@@RES=")[1].split("\n")[0].strip()
    msg = o.split("@@MSG")[1] if "@@MSG" in o else ""
    first = " ".join(l.strip() for l in msg.splitlines()
                     if l.strip() and not l.startswith("@@") and re.search(r"rror|ssert|ailed", l))[:300]
    if "Simulation execution failed" in msg:
        return ("sim_assert" if re.search(r"assert", msg, re.I) else "sim_fail"), first
    if not rf:
        return "build_fail", first or "no result file"
    if re.search(r"simulation terminated by an assertion|integrator failed|Simulation process failed|failed to solve", msg, re.I):
        return "sim_fail", first
    return "sim_ok", ""

def run1(name, load, backend, extra, tmo):
    d = tempfile.mkdtemp(prefix="r", dir=".")
    opts = "--std=latest" + (" --newBackend" if backend == "new" else "")
    mos = ('setCommandLineOptions("%s"); getErrorString();\n%s getErrorString();\n'
           'res := simulate(%s%s); print("\\n@@RES=" + res.resultFile + "\\n@@MSG\\n" + res.messages + "\\n@@ERR\\n" + getErrorString() + "\\n");\n'
           % (opts, load, name, extra))
    open(d + "/s.mos", "w").write(mos)
    t = time.time()
    try:
        o = subprocess.run(["timeout", "-s", "KILL", str(tmo), OMC, "s.mos"], cwd=d, capture_output=True, text=True, errors="replace").stdout
    except Exception as e:
        o = str(e)
    secs = time.time() - t
    shutil.rmtree(d, ignore_errors=True)
    lines = [l for l in o.splitlines() if not l.startswith("clang ")]
    open("out/logs/%s/%s.txt" % (backend, name), "w").write("\n".join(lines[-80:]) + "\n")
    st, msg = classify(o)
    return st, msg.replace("\t", " "), secs

def main():
    mode = sys.argv[1]
    jobs = []
    if mode == "compl":
        sh, n = int(sys.argv[2]), int(sys.argv[3]); tag = "compl-%d" % sh
        lib = os.path.abspath("mclib/ModelicaCompliance/package.mo")
        for i, l in enumerate(open(HERE + "/compl/tests.tsv")):
            f = l.rstrip("\n").split("\t")
            if i % n != sh: continue
            jobs.append((f[0], f[1], f[2], 'loadFile("%s");' % lib, ", stopTime=%s" % f[4], 300))
    else:
        L, sh, n = sys.argv[2], int(sys.argv[3]), int(sys.argv[4]); tag = "lib-%s-%d" % (L, sh)
        for i, l in enumerate(open(HERE + "/libs/%s.lst" % L)):
            if i % n != sh or not l.strip(): continue
            jobs.append((l.strip(), "-", L, "loadModel(%s);" % L, "", 900))
    out = open("out/%s.tsv" % tag, "w")
    def go(j):
        name, sp, ch, load, extra, tmo = j
        rows = []
        for b in ("old", "new"):
            st, msg, secs = run1(name, load, b, extra, tmo)
            ok = st == "sim_ok"
            if sp == "true": v = "ok" if ok else "wrong_reject"
            elif sp == "false": v = "wrong_accept" if ok else "ok"
            else: v = "ok" if ok else "fail"
            rows.append("\t".join([name, sp, ch, b, st, v, "%.1f" % secs, msg]))
        return rows
    with cf.ThreadPoolExecutor(int(os.environ.get("J", "3"))) as ex:
        for rows in ex.map(go, jobs):
            out.write("\n".join(rows) + "\n"); out.flush()
            print(rows[0][:150]); print(rows[1][:150]); sys.stdout.flush()

main()
