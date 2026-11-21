/NLS .*digitsLost/ { sub(/.*digitsLost=/, ""); if ($1 > d) d = $1 }
END { printf "%.0e\n", 10^d }
