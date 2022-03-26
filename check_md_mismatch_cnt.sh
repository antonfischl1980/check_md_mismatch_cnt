#!/bin/bash

WARNING=1
CRITICAL=1
MD_IS_OPTIONAL=0

usage() {
  echo -e "Usage: $0 [-w <warning>] [-c <critical>] [-o]\n -w <warning> \tWarning threshold for mismatch_cnt (OPTIONAL, default: 1)\n -c <critical> \tCritical threshold for mismatch_cnt (OPTIONAL, default: 1 (always critical, no warning))\n -o \t\tIndicate that it is OK for there to be no software raid (without this flag UNKNOWN is returned if no software raid is found)\n -h\t\tDisplays this help message\n" 1>&2;
  exit 3;
}

# check for command line arguments
while getopts ":w:c:h:o" option; do
  case "${option}" in
    w) WARNING=${OPTARG};;
    c) CRITICAL=${OPTARG};;
    o) MD_IS_OPTIONAL=1;;
    h) usage;;
    *) usage;;
  esac
done

# WARNING and CRITICAL must be decimal numbers
echo "$WARNING"|grep -qE "^[0-9]+$" || usage
echo "$CRITICAL"|grep -qE "^[0-9]+$" || usage

# Resets position of first non-option argument
shift "$((OPTIND-1))"

DATA=0
MD_FOUND=0
PERF_DATA=""
while read file
do
  DATA2="$(cat "$file")"
  DATA="$((DATA + DATA2))"
  MD_NAME=$(echo "$file" | awk -F '/' '{print $4}')
  PERF_DATA+=" $MD_NAME=$DATA2"
  MD_FOUND=1
done < <( find /sys/block/md*/md/mismatch_cnt 2>/dev/null )

if [ $MD_FOUND -eq 0 ]; then
  if [ $MD_IS_OPTIONAL -eq 0 ]; then
    echo "UNKNOWN - software raid mismatch_cnts not found - no software raid active?"
    exit 3;
  else
    echo "OK - software raid mismatch_cnts not found - no software raid active"
    exit 0
  fi
fi

if [ $DATA -ge $CRITICAL ]; then
  echo "CRITICAL - software raid mismatch_cnts are greater or equal than $CRITICAL |$PERF_DATA"
  exit 2;
elif [ $DATA -ge $WARNING ] ; then
  echo "WARNING - software raid mismatch_cnts are greater or equal than $WARNING |$PERF_DATA"
  exit 1;
else 
  echo "OK - all software raid mismatch_cnts are smaller than $WARNING |$PERF_DATA"
  exit 0;
fi
