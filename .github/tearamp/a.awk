/digitsLost/ { sub(/.*digitsLost=/, ""); if ($1 > d) d = $1 }
/simulation finished successfully/ { s++ }
FNR == 2 && FILENAME ~ /csv/ { for (i = 2; i <= split($0, v, ","); i++) if (FILENAME ~ /F/) f[i] = v[i]; else if ((x = f[i] / v[i] - 1)^2 > e^2) e = x }
END { printf "%2d %6.0e %7.1e %s\n", N, 10^d, e < 0 ? -e : e, s == 2 ? "yes" : "no" }
