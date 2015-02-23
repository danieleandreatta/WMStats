#!/usr/bin/mawk -f

function find_top() {
    m_i = 0
    m_a = a[0]
    m_b = b[0]
    for (i in a) {
        if (m_b < b[i]) {
            m_i = i
            m_a = a[i]
            m_b = b[i]
        }
    }
}

function min(a,b) {
  if (a<b) { return a }
  else { return b }
}

BEGIN {
    "date +%s.%N0" | getline t0;
    n = 0
}
$1=="en" && $3>500 {
    a[n]=$2; b[n]=$3; ++n;
}
END {
    for (j=0; j<min(10, n); ++j) {
        find_top()
        x[j] = m_a
        y[j] = m_b
        b[m_i] = 0
    }
    "date +%s.%N1" | getline t1;
    printf "Query took %.2f seconds\n", t1-t0;
    for (i=0; i<min(n, 10); ++i) {
        printf "%s (%d)\n", x[i], y[i];
    }
}
