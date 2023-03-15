#!/bin/bash

log_files=$(find . -name "log*.txt")

if [ $# -ne 1 ]; then
    echo "Error: Invalid number of parameters."
    echo "Usage: $0 [1|2|3|4]"
    exit 1
fi

case $1 in
    1) for var in $log_files
        do
        awk '{print $9}' $var | sort | uniq -c | sort -n 
        done ;;
    2) for var in $log_files
        do awk '{print $1}' $log_files | sort | uniq -c | sort -n
        done ;;
    3) for var in $log_files
        do awk '($9 >= 400) {print}' $log_files | sort | uniq -c | sort -n 
        done ;;
    4) for var in $log_files 
    do
    awk '($9 >= 400) {print $1}' $log_files | sort | uniq -c | sort -n 
    done
    ;;
    *) echo "Error: Invalid parameter value."
       echo "Usage: $0 [1|2|3|4]"
       exit 1
       ;;
esac
