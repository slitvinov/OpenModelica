#!/usr/bin/env python3
"""maps.py results.tsv... : threshold maps from run.mos output.

One row per (model, mode, nominal, solver): a character per k (KMIN..KMAX):
  . OK (err <= 1e-4)   w OK but LS/NLS failure messages in the log (recovered)
  i INACC (1e-4 < err <= 1e-2)   X WRONG (rc = 0, err > 1e-2 or NaN)   F FAIL (rc != 0)
and the contiguous OK range around k = 0 ("ok k" columns; '.' and 'w' count as OK).
"""
import sys, csv, collections

rows = []
for f in sys.argv[1:]:
    with open(f) as fh:
        rows += [r for r in csv.DictReader(fh, delimiter='\t')]
ks = sorted({int(r['k']) for r in rows})
sym = {'OK': '.', 'INACC': 'i', 'WRONG': 'X', 'FAIL': 'F'}
g = collections.OrderedDict()
for r in rows:
    c = sym[r['class']]
    if c == '.' and r['warn'] == 'W':
        c = 'w'
    g.setdefault((r['model'], r['mode'], r['nominal'], r['solver']), {})[int(r['k'])] = c


def okrange(d):
    if d.get(0) not in ('.', 'w'):
        return 'k=0 fails'
    lo = hi = 0
    while d.get(lo - 1) in ('.', 'w'):
        lo -= 1
    while d.get(hi + 1) in ('.', 'w'):
        hi += 1
    return '%d..%d' % (lo, hi)


hdr = ''.join(('|' if k == 0 else ' ') if k % 2 == 0 and k != 0 else ('0' if k == 0 else ' ') for k in ks)
last = None
for (m, mode, nom, sol), d in g.items():
    if (m, mode) != last:
        print('\n%s mode %s   k = %d..%d (0 marked)' % (m, mode, ks[0], ks[-1]))
        print('%-6s %-20s %s  %s' % ('nom', 'solver', hdr, 'ok k'))
        last = (m, mode)
    print('%-6s %-20s %s  %s' % (nom, sol, ''.join(d.get(k, ' ') for k in ks), okrange(d)))
