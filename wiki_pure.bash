#!/bin/bash

PAGES=()
HITS=()

sort_hits(){
    # Bubble sort because it is easy, sorry
    local i j t
    for ((i=1; i<${#PAGES[*]}; ++i)); do
        for ((j=0; j < ${#PAGES[*]} - i; ++j)); do
            if ((HITS[j] < HITS[j+1])); then
                t="${HITS[j]}"
                HITS[j]="${HITS[j+1]}"
                HITS[j+1]="${t}"
                t="${PAGES[j]}"
                PAGES[j]="${PAGES[j+1]}"
                PAGES[j+1]="${t}"
            fi
        done
    done
}

T0=$SECONDS

while read -r lang page hits other; do
    if [[ "$lang" == "en" ]]; then
        if ((hits > 500)); then
            PAGES[${#PAGES[*]}]=$page
            HITS[${#HITS[*]}]=$hits
        fi
    fi
done < $1

sort_hits

T1=$SECONDS

printf "Query took %d seconds\n" $((T1 - T0))
N=10
if ((${#PAGES[*]} < 10)); then
  N=${#PAGES[*]}
fi
for ((i=0; i<N; ++i)) ; do
    printf "%s (%s)\n" ${PAGES[i]} ${HITS[i]}
done
