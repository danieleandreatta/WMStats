#!/bin/bash
#vim: ai sw=2 ts=2 et

set +u
set +x
set +v

FILE_SHORT=pagecounts_sampled_100
EXPECTED_SHORT='0b5ea913c36c45e7acf77ae6ab9e961e'

FILE_LONG=pagecounts-20141029-230000
EXPECTED_LONG='8474f269f4bf49475b63b46a858748ca'

export LC_ALL='C'

if [[ $OSTYPE == cygwin ]]; then
  MAX_MEM=unlimited # cygwin does not support limiting virtual memory
else
  MAX_MEM=1300000   # use max 1GB of memory, enforced w/ ulimit -v
fi

CYCLES=1
SHORT=0
TOUT=1000
while getopts 'n:st:' opt; do
    case $opt in
    n)  CYCLES=$OPTARG ;;
    s)  SHORT=1;;
    t)  TOUT=$OPTARG ;;
esac
done
shift $((OPTIND-1))

if [[ $SHORT == '1' ]]; then
    FILE="$FILE_SHORT"
    EXPECTED="$EXPECTED_SHORT"
else
    FILE="$FILE_LONG"
    EXPECTED="$EXPECTED_LONG"
fi

run_test () {

  set +x
  local TIME_SUM=0
  local OUT TIME ANS

  printf "%-35s " "$1"

  TIME_SUM=0
  for ((i=0; i<CYCLES; ++i)); do
    if OUT=$(ulimit -v $MAX_MEM; timeout $TOUT $1 $FILE 2>/dev/null); then
      TIME=($(echo "$OUT" | head -n 1))
      TIME_SUM=$(dc -e "2k $TIME_SUM ${TIME[2]} + p")
    fi
  done

  ANS=$(echo "$OUT" | tail -n +2 | sort | md5sum | cut -d' ' -f1)

  if [[ "$ANS" == "$EXPECTED" ]]; then
      OK=OK
  else
      echo $OUT
      OK=FAIL
  fi

  AVG_TIME=$(dc -e "2k $TIME_SUM $CYCLES / p")

  printf "%4s %6.2f \n" "$OK" "$AVG_TIME"
}

for t in "$@"; do
    run_test "$t"
done

