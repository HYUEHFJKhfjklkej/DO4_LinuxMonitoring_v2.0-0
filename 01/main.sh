#!/bin/bash
cd $(dirname $0) 
if [ $# != 6 ];
then
    echo "Error: more then 6 param"
    exit
else
    ABS_PATH=$1
    if ! [ -d $ABS_PATH ]; then
        echo "Error <FIRST PAR>: <$ABS_PATH> not directory, enter /<directory name>/"
        exit
    fi
    COUNT_DIR=$2
    if [[ $COUNT_DIR =~ ^[0-9] ]] && [[ $COUNT_DIR -gt 0 ]];then
        :
    else
        echo "Error SECOND PAR incorrect $COUNT_DIR"
        exit
    fi
    ALPHABET_DIR=$3
    LENGTH_DIR_ALPHABET=`expr length $ALPHABET_DIR`
    if [[ $LENGTH_DIR_ALPHABET -le 7 ]] && [[ $ALPHABET_DIR =~ ^[a-z]+$ ]];then
        :
    else 
        echo "Error THIRD PAR: incorrect $ALPHABET_DIR"
        exit
    fi
    COUNT_FILES=$4
    if [[ $COUNT_FILES =~ ^[0-9]+$ ]];then 
        :
    else
        echo "Error FOURTH PAR: incorrect $COUNT_FILES"
        exit
    fi
    if [[ $5 =~ ^[a-z]+[.]+[a-z]+$ ]];then 
        ALPHABET_FILE="${5%.[^.]*}"
        LENGTH_FILE_ALPHABET=`expr length $ALPHABET_FILE`
        ALPHABET_EXT="${5##*.}"
        LENGTH_EXT_ALPHABET=`expr length $ALPHABET_EXT`
        if [[ $ALPHABET_FILE_ALPHABET -le 7 && $ALPHABET_EXT_ALPHABET -le 3 ]];then
            :
        else 
            echo "Error FIFTH PAR: incorrect $5"
            exit
        fi
    else
        echo "Error <FIFTH PAR>: $5"
        exit
    fi
      SIZE_FILE=`echo $6 | egrep -o ^[0-9+$]*`
    if [[ $SIZE_FILE -le 0 ]] || [[ $SIZE_FILE -gt 100 ]];then
        echo "Error <SIXTH PAR> must be <=100"
    else
        :
    fi
fi
cd `dirname $0`
PATH_TO_SCRIPT=`pwd`
DATE_NAME=$(date +%D | awk -F / '{print $2$1$3}')

function name_generator {
            ALPHABET=$1
            LENGTH_ALPHABET=`expr length $ALPHABET 2> /dev/null`
        for (( i=1; i<=$LENGTH_ALPHABET; i++ ))
        do
            arr[$i]=`expr substr $ALPHABET $i 1 2> /dev/null`
            NAME+="${arr[$i]}"
        done
            echo $NAME
    }
    function add_Sign {
            NAME=$1
            ALPHABET=$2
            SYMBOL=$3
            LENGTH_ALPHABET=`expr length $ALPHABET 2> /dev/null`
        for (( i=1; i<=$LENGTH_ALPHABET; i++ ))
        do
            arr[$i]=`expr substr $ALPHABET $i 1 2> /dev/null`
        done
            INDEX_SIGN=`expr index $NAME ${arr[$SYMBOL]} 2> /dev/null`
            TMP_NAME=$(expr substr $NAME 1 $INDEX_SIGN 2> /dev/null)${arr[$SYMBOL]}$(echo ${NAME:$INDEX_SIGN})
            NAME=$TMP_NAME
        echo $NAME
    }
    touch $PATH_TO_SCRIPT/logs_file.txt
    echo -n "" > $PATH_TO_SCRIPT/logs_file.txt
    for ((j=0; j<$COUNT_DIR; j++))
    do
        cd $ABS_PATH
        FREE_SPACE_MB=$(df / |  head -2 | tail +2 | awk '{printf("%d", $4)}')
        if [[ $FREE_SPACE_MB -le 1048576 ]]
        then
            break
        else
            :
        fi
        #CREATE FOLDER
        NAME_DIR=$(name_generator $ALPHABET_DIR)
        TMP_NAME_DIR=$NAME_DIR"_"$DATE_NAME
        CHAR=0
        while [ -e "$TMP_NAME_DIR" ] || [[ `expr length $NAME_DIR` -lt 4 ]];
        do
            if [[ CHAR -ge `expr length $ALPHABET_DIR` ]] || [[ `expr length $ALPHABET_DIR` -eq 1 ]];then
                CHAR=1
            else
                CHAR=$(($CHAR+1))
            fi
            NAME_DIR=$(add_Sign $NAME_DIR $ALPHABET_DIR $CHAR)
            TMP_NAME_DIR=$NAME_DIR"_$DATE_NAME"
        done
        mkdir $TMP_NAME_DIR
        echo $(pwd)"/$TMP_NAME_DIR/" `date +%Y-%m-%d-%H-%M` >> $PATH_TO_SCRIPT/logs_file.txt
        
        #CREATE FILES
        for ((f=0;f<$COUNT_FILES; f++))
        do
            CHAR_FILE=0
            NAME_FILE=$(name_generator $ALPHABET_FILE)
            FILE=$TMP_NAME_DIR"/$NAME_FILE.$ALPHABET_EXT"
            while [ -e $FILE ] || [[ `expr length $NAME_FILE` -lt 4 ]];
            do
                if [[ CHAR_FILE -ge `expr length $ALPHABET_DIR` ]] || [[ `expr length $ALPHABET_FILE` -eq 1 ]];then
                    CHAR_FILE=1
                else
                    CHAR_FILE=$(($CHAR_FILE+1))
                fi
                NAME_FILE=$(add_Sign $NAME_FILE $ALPHABET_FILE $CHAR_FILE)
                FILE=$TMP_NAME_DIR"/$NAME_FILE.$ALPHABET_EXT"
            done
            touch $FILE
            fallocate -l $SIZE_FILE"KB" $FILE 2> /dev/null
            echo $(pwd)"/$FILE" `date +%Y-%m-%d-%H-%M` `ls -lh $FILE 2> /dev/null | awk '{print $5}'` >>  $PATH_TO_SCRIPT/logs_file.txt
            FREE_SPACE_MB=$(df / |  head -2 | tail +2 | awk '{printf("%d", $4)}')
            if [[ $FREE_SPACE_MB -le 1048576 ]];then
                exit 1
        fi
    done
done
