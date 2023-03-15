#!/bin/bash

if [ $# -ne 1 ] || ! [[ $1 =~ ^[1-3]$ ]]; then
  echo "Usage: $0 [1|2|3]"
  echo "1 - Clean by log file"
  echo "2 - Clean by date and time of creation"
  echo "3 - Clean by name mask (letters, underscore, date)"
  exit 1
fi
``

case $1 in
  1)
    # Clean by log fil
    logs=$(cat logs_file.txt | awk '{print $1}')
    for i in $logs 
    do
    if [[ ${i: 0:1} == "/" ]]; then
        echo "rm -rf" $i
        rm -rf $i
    fi
    done
    ;;
  2)
    # Clean by date and time of creation
    read -p "(start: YYYY-MM-DD HH:MM)" start 
    read -p "(end: YYYY-MM-DD HH:MM)" end
    date_tmp=`find / -newermt "$start" ! -newermt "$end" 2>/dev/null | sort -r`
    for i in $date_tmp
    do
    if [[ ${i: 0:1 } == "/" ]]
        then
            echo "rm -rf" $i
            rm -rf $i
        fi
    done
    ;;
  3)
    # Clean by name mask (letters, underscore, date)
    echo "input slould be like: foldername_$(date '+%d%m%y') or filename_$(date '+%d%m%y').ext"
    read -p "enter the namemask: " nameMask
    name=$(echo $nameMask | awk -F"_" '{ print $1 }')
    end=$(echo $nameMask | awk -F"_" '{ print $2 }')
    rm -rf $(find / -type f -name "*$name*$end" 2>/dev/null)
    rm -rf $(find / -type d -name "*$name*$end" 2>/dev/null)
    ;;
esac

exit 0
