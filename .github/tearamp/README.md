# Tearing amplification

- `M.mo`: a rod with N nodes (conduction 1, convection 10 to the ambient, a non-linear tip). `s.mos` simulates it with the default tearing and with noTearing; `a.awk` reads omc's output and the two result files and prints N, the amplification that omc itself computes for the torn system (`-d=tearingCost`, `digitsLost`), the largest relative difference to noTearing, and whether both runs report success.
- `pred.py OMC`: the 480 generated cases of the tearing suite (`gen.py`, #18244) with the default tearing; `amp.awk` takes the amplification from omc's `-d=tearingCost` output; the table counts the cases solved per amplification band.
