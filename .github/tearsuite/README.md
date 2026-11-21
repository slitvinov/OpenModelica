# Tearing suite with --tearingMaxAmplification

The 480 generated cases of the tearing test suite (#18244): non-linear systems with exactly one solution and a known exact answer.

- `gen.py OUTDIR`: generates the cases (`mono`: strongly monotone `A*x + g(x) = b`; `heat`: steady heat network).
- `tsuite.py OMC OUT FLAGS [SHARD NSHARDS]`: builds each case with `cellier` and `omcTearing` plus FLAGS, runs it, and compares it with the exact solution. It also counts the "Tearing is skipped" notifications and records the iteration variables of each non-linear system.
- `tcmp.py LABEL=RES.tsv...`: OK counts of the runs side by side and the cases that change.

CI (`.github/workflows/tearcheck.yaml`) builds omc from this branch, runs the suite with the flag off and with `--tearingMaxAmplification=1e5` and `1e4` in 12 jobs, and prints the tables to the log and the summary.
