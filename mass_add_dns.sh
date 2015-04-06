#!/bin/bash

#TODO:
# make it work
# add validation
# add error handling

if [[ $# -lt 1 ]]; then
	echo Нет пути к файлу, завершение
	exit 1
fi

HOSTFILE=$1

while read line
do  

    HOSTNAME=$(echo $line | awk '{print $1}')
    IP=$(echo $line | awk '{print $2}')
    if [[ $(echo $HOSTNAME | grep -o "\." | wc -l) -eq 2 ]]; then
    	DOMAIN=$(echo $HOSTNAME | cut -d'.' -f2-)
    else
    	DOMAIN=$(echo $HOSTNAME | cut -d'.' -f3-)
    fi	
    LABEL=$(echo $line | awk '{print $3}')
    
    if [[ $LABEL != "" ]]; then
    	./add_record.sh $HOSTNAME $IP $DOMAIN 1
    else
    	./add_record.sh $HOSTNAME $IP $DOMAIN 
    fi 
done < $HOSTFILE