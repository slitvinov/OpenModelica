"""gen.py OUTDIR: parametric non-linear systems with a provably unique solution and a known exact answer.
mono: A*x + g(x) = b, A = D + S (D positive diagonal, S antisymmetric, sparse), g_i increasing in x_i.
      (F(x)-F(y))'(x-y) >= min(D)|x-y|^2, so F is strongly monotone: exactly one solution.
heat: steady heat network, T[n] and Q[m] unknown, Q[e] = G_e*(T[i]-T[j]) + H_e*(T[i]^3-T[j]^3),
      node balances, node n tied to ambient. dF/dT is a Z-matrix with zero column sums plus the
      ambient term (non-singular M-matrix, hence P-matrix) for every T: F is injective (Gale-Nikaido).
Knobs: n; mono: kappa (coupling |S|/D), sigma (decades of spread of D and S), phi (fraction of rows
with g_i); heat: r (decades of spread of G), c (fraction of edges with a cubic term)."""
import sys, os, json, random, math
OUT = sys.argv[1]
G = {"sinh": (lambda c, v: "%s*sinh(%s)" % (c, v), lambda c, x: c * math.sinh(x)),
     "pow5": (lambda c, v: "%s*%s^5" % (c, v), lambda c, x: c * x ** 5),
     "pow3": (lambda c, v: "%s*%s^3" % (c, v), lambda c, x: c * x ** 3),
     "exp": (lambda c, v: "%s*exp(%s)" % (c, v), lambda c, x: c * math.exp(x)),
     "atan": (lambda c, v: "%s*atan(%s)" % (c, v), lambda c, x: c * math.atan(x))}
f4 = lambda v: float("%.4g" % v)
def term(c, v, first=False):
    s = "%.4g*%s" % (abs(c), v)
    return (("-" if c < 0 else "") + s) if first else ((" - " if c < 0 else " + ") + s)
def mono(n, kappa, sigma, phi, seed):
    rng = random.Random("mono%d %g %g %g %d" % (n, kappa, sigma, phi, seed))
    x = [round(rng.uniform(-0.8, 0.8), 3) for _ in range(n)]
    d = [f4(10 ** (sigma * rng.uniform(-1, 1))) for _ in range(n)]
    pairs = {(i, (i + 1) % n) for i in range(n)}
    while len(pairs) < n + n // 2:
        i, j = rng.sample(range(n), 2)
        if (i, j) not in pairs and (j, i) not in pairs: pairs.add((i, j))
    S = {}
    for i, j in pairs:
        s = f4(rng.choice((-1, 1)) * kappa * 10 ** (sigma * rng.uniform(-1, 1)))
        S[(i, j)] = s; S[(j, i)] = -s
    nl = set(rng.sample(range(n), max(1, round(phi * n))))
    lines, ex = [], {}
    for i in range(n):
        txt = term(d[i], "x%d" % (i + 1), True); val = d[i] * x[i]
        for j in range(n):
            if (i, j) in S: txt += term(S[(i, j)], "x%d" % (j + 1)); val += S[(i, j)] * x[j]
        if i in nl:
            k = rng.choice(sorted(G)); c = f4(rng.uniform(0.2, 0.6) * d[i])
            txt += " + " + G[k][0]("%.4g" % c, "x%d" % (i + 1)); val += G[k][1](c, x[i])
        lines.append("  %s = %.17g;" % (txt, val))
    for i in range(n): ex["x%d" % (i + 1)] = x[i]
    mo = "model M\n" + "".join("  Real x%d;\n" % (i + 1) for i in range(n)) + "equation\n" + "\n".join(lines) + "\nend M;\n"
    return mo, ex, {}
def heat(n, r, cfrac, seed):
    rng = random.Random("heat%d %g %g %d" % (n, r, cfrac, seed))
    T = [round(rng.uniform(0.6, 1.4), 3) for _ in range(n)]
    E = [(rng.randrange(k), k) for k in range(1, n)]
    while len(E) < n - 1 + n // 2:
        i, j = rng.sample(range(n), 2)
        if (i, j) not in E and (j, i) not in E: E.append((i, j))
    E = [(i, j) if rng.random() < 0.5 else (j, i) for i, j in E]
    Gs = [f4(0.1 * 10 ** (r * rng.uniform(0, 1))) for _ in E]
    cub = set(rng.sample(range(len(E)), max(1, round(cfrac * len(E)))))
    Hs = [f4(Gs[e] * rng.uniform(0.05, 0.15)) if e in cub else 0.0 for e in range(len(E))]
    Q = [Gs[e] * (T[i] - T[j]) + Hs[e] * (T[i] ** 3 - T[j] ** 3) for e, (i, j) in enumerate(E)]
    Gb, Ta = 0.452, 0.778
    st = [round(T[k] * (1 + 0.4 * rng.uniform(-1, 1)), 3) for k in range(n)]
    L = ["model M", "  Real T[%d](start = {%s});" % (n, ", ".join("%g" % s for s in st)), "  Real Q[%d];" % len(E), "equation"]
    for e, (i, j) in enumerate(E):
        s = "  Q[%d] = %.4g*(T[%d] - T[%d])" % (e + 1, Gs[e], i + 1, j + 1)
        if Hs[e]: s += " + %.4g*(T[%d]^3 - T[%d]^3)" % (Hs[e], i + 1, j + 1)
        L.append(s + ";")
    for k in range(n):
        txt, val = "", 0.0
        for e, (i, j) in enumerate(E):
            if j == k: txt += " + Q[%d]" % (e + 1); val += Q[e]
            if i == k: txt += " - Q[%d]" % (e + 1); val -= Q[e]
        if k == n - 1: txt += " - %g*(T[%d] - %g)" % (Gb, n, Ta); val -= Gb * (T[k] - Ta)
        L.append("  0 = %s %s %.17g;" % (txt.strip(" +"), "-" if val > 0 else "+", abs(val)))
    L.append("end M;")
    ex = {"T[%d]" % (k + 1): T[k] for k in range(n)}; ex.update({"Q[%d]" % (e + 1): Q[e] for e in range(len(E))})
    return "\n".join(L) + "\n", ex, {"T[%d]" % (k + 1): st[k] for k in range(n)}
NS = [5, 8, 12, 16, 20, 30, 45, 60]
cases = []
for n in NS:
    for kappa in (0.3, 1, 3):
        for sigma in (0, 1, 2):
            for phi in (0.3, 1.0):
                for seed in (1, 2):
                    cases.append(("mono_n%d_k%g_s%g_p%g_%d" % (n, kappa, sigma, phi, seed), mono(n, kappa, sigma, phi, seed),
                                  dict(family="mono", n=n, kappa=kappa, sigma=sigma, phi=phi, seed=seed)))
    for r in (0, 2, 3, 4):
        for c in (0.25, 1.0):
            for seed in (1, 2, 3):
                cases.append(("heat_n%d_r%g_c%g_%d" % (n, r, c, seed), heat(n, r, c, seed),
                              dict(family="heat", n=n, r=r, c=c, seed=seed)))
for cid, (mo, ex, st), p in cases:
    d = os.path.join(OUT, cid); os.makedirs(d, exist_ok=True)
    open(d + "/M.mo", "w").write(mo)
    json.dump(dict(params=p, exact=ex, start=st, model="M"), open(d + "/meta.json", "w"), indent=0)
print(len(cases), "cases")
