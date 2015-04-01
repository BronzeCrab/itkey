#!/bin/bash

HOST=$1
IP=$2
DOMAIN=$3
MODE=$4
RECORD="${HOST} IN A ${IP}"

# TODO:
# arg count check
# zonefile check
# validate ip
# add error handling

if [[ $# < 3 ]]; then
	echo Слишком мало параметров!
	exit 1
elif [[ ! -f /etc/bind/zones/${DOMAIN}.db ]]; then
	echo Файла c зонами не существует
	exit 1
elif [[]]; then
	
fi



if [ "$MODE" == "1" ]; then
        sed -i 's/'"$RECORD"'//g' /etc/bind/${DOMAIN}.db
elif [ "$(cat /etc/bind/${DOMAIN}.db | grep "${RECORD}")" == "" ]; then
        echo -e $RECORD >> /etc/bind/${DOMAIN}.db
fi

service bind9 restart