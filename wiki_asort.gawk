#!/usr/bin/gawk -f

function min(a,b) {
  if (a<b) { return a }
  else { return b }
}

BEGIN {
    "date +%s.%N0" | getline t0;
    n = 0
}
$1=="en" && $3>500 {
    n++
    a[n]=sprintf("%0.10d %s", $3, $2);
}
END {
    asort(a, a, "@val_str_desc");
    "date +%s.%N1" | getline t1;
    printf "Query took %.2f seconds\n", t1-t0;
    for (i=1; i<=min(10, n); ++i) {
        split(a[i], b, " ")
        printf "%s (%d)\n", b[2], b[1];
    }
}
