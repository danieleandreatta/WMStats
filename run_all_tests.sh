#!/bin/bash

#S=''
#T=''
#while getopts 'st:' opt; do
#  case $opt in
#  s)  S='-s' ;;
#  t)  T="-t $OPTARG" ;;
#  *)  ;;
#  esac
#done

find . -maxdepth 1 -type f -perm /u+x -name 'wiki*' | xargs ./run_tests.sh $@
