#!/bin/bash

T=$(mktemp)
T0=$(date +%s.%N)
OUT=$(grep '^en ' $1 | awk '$3>500' | cut -d' ' -f 2,3 | sort -rn -k2 | head -10)
T1=$(date +%s.%N)

printf "Query took %.2f seconds\n" $(echo $T1 - $T0 | bc -l)
echo "$OUT" | xargs printf "%s (%d)\n"
