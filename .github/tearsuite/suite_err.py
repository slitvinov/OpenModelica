"""err(): the comparison of suite.py, shared with tsuite.py."""
import csv
def err(fn, ex):
    try: rows = list(csv.reader(open(fn)))
    except Exception: return None
    if len(rows) < 2: return None
    h = rows[0]; e = 0.0
    if any(k not in h for k in ex): return None   # a missing solution variable is FAIL
    for r in rows[1:]:
        for k, v in ex.items():
            if k in h:
                try: x = float(r[h.index(k)])
                except ValueError: return float("inf")
                except IndexError: return None   # a cut csv row
                d = abs(x - v) / (abs(v) + 1e-3)
                e = max(e, d if d == d else float("inf"))
    return e
