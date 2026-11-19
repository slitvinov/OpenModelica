# Tearing test suite (#18244)

Non-linear systems with exactly one solution and a known exact answer.

- `mono`: `A*x + g(x) = b`, `A` = positive diagonal + antisymmetric, `g_i` increasing in `x_i`. The map is strongly monotone, thus the solution is unique.
- `heat`: steady heat network, `Q[e] = G*(T[i] - T[j]) + H*(T[i]^3 - T[j]^3)`, node balances, one node tied to ambient. The Jacobian is a non-singular M-matrix for all `T`, thus the solution is unique (Gale-Nikaido).

Files:

- `gen.py OUTDIR`: generates the 480 cases (knobs: size `n`, coupling `kappa`, coefficient spread `sigma`, fraction of non-linear rows `phi`; conductance spread `r`, fraction of cubic edges `c`).
- `cases/`: the smallest failing cases, `U` (#18250) and `S18176` (#18176); `<name>.json` is the exact solution.
- `ci.py OMC`: builds each case with each tearing and prints OK, WRONG (success reported, values differ from the exact solution) or FAIL.
- `ana.py`: torn Jacobian (Schur complement of the block, from `<prefix>_info.json`) at the exact solution, its condition number and `max |d inner / d iteration var|`.
