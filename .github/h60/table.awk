# Print one row per KINSOL try of the first nonlinear solve in a -lv=LOG_NLS,LOG_NLS_V log
/Initial guess values$/ { getline; n = split($0, a, "="); x0 = a[n]; gsub(/ /, "", x0); next }
/\| fScaling$/ { getline; n = split($0, a, "]"); fs = a[n]; gsub(/ /, "", fs); next }
/KINSOL current retry/ { r = $NF; next }
/KINSol finished with errorCode/ { e = $NF; sub(/\.$/, "", e); printf "| %s | %s | %s | %s |\n", r, x0, fs, e; next }
/Solution status/ { print "first solve: " $NF; exit }
BEGIN { print "| try | T[30] at start | fScaling[1] | KINSol flag |"; print "|---|---|---|---|" }
