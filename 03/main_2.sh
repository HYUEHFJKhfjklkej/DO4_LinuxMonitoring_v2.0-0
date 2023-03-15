#!/bin/bash

if [[ $# -ne 3 ]]
then
    echo "Erorr more then 3 argv"
    exit 1
fi
reg1='^[a-zA-Z]{1,7}$'
if ! [[ $1 =~ $reg1 ]]
then
    echo "Erorr more then 7 letters"
    exit 1
fi
reg2='^[a-zA-Z]{1,7}[.][a-zA-Z]{1,3}$'
if ! [[ $2 =~ $reg2 ]]
then
    echo "File name should be less then 7 letters and extansion should be betwen 1 and 3 letters"
    exit 1
fi
reg3='^[1-9][0-9]?[0]?Mb$'
if ! [[ $3 =~ $reg3 ]]
then
    echo "Erorr must be < 100"
    exit 1
fi

touch logs_file.txt
start_path=$(pwd)
start_time=$(date +'%Y-%m-%d %H:%M:%S')
start_sec=$(date +'%s%N')
echo "Script started at $start_time" >> logs_file.txt
echo "Script started at $start_time"
dir_name=$1
dir_date="$(date +"%d%m%y")"
if [[ ${#dir_name} -lt 5 ]]
then
    for (( i=${#dir_name}; i<5; i++ ))
    do
        dir_name+=${1: -1}
    done
fi
dirs_n=$(echo $(( 1 + $RANDOM % 100 )))

for (( i=0; i<$dirs_n; i++ ))
do
    random_dir="$(compgen -d / | shuf -n1)" # "compgen -d" это команда в системе Linux, которая используется для генерации списка директорий "shuf -n1" это команда в системе Linux, которая используется для выбора случайной строки из списка строк,
    file_n="$(shuf -i 1-50 -n1)"
    if [[ $random_dir == "/bin" || $random_dir == "/sbin" ]]
    then
        dirs_n=$(( $dirs_n + 1 ))
        continue
    fi
    dir_path=$random_dir"/"$dir_name"_"$dir_date
    dir_name+=${1: -1}
    echo mkdir -p $dir_path 
    mkdir -p $dir_path 2>/dev/null
    dir_path+="/"
    echo $dir_path" $(date +'%e.%m.%Y')" >> logs_file.txt
    file_ext=$(echo $2 | awk -F. '{print $2}')
    file_name=$(echo $2 | awk -F. '{print $1}')
    file_last=${file_name: -1}
    if [[ ${#file_name} -lt 5 ]]
    then
        for (( j=${#file_name}; j<5; j++ ))
        do
            file_name+=$file_last
        done
    fi
    for (( j=0; j<$file_n; j++ ))
    do
        if [[ $(df / -BM | grep "/" | awk -F"M" '{ print $3 }') -le 1024 ]]
        then
            echo "No available disk space"
            j=$file_n
            i=$dirs_n
            continue
        fi
        full_name=$file_name"_"$dir_date"."$file_ext
        file_name+=$file_last
        fallocate -l $3 $dir_path$full_name 2>/dev/null
        echo $dir_path$full_name" $(date +'%e.%m.%Y') "$3 >> logs_file.txt
    done
done
cd $start_path
end_time=$(date +'%Y-%m-%d %H:%M:%S')
end_sec=$(date +'%s%N')
echo "Script finished at $end_time" >> logs_file.txt
echo "Script finished at $end_time"
dif_sec=$((( $end_sec - $start_sec ) / 100000000 ))
echo "Script wore executed for $dif_sec secconds" >> logs_file.txt
echo "Script wore executed for $dif_sec secconds"