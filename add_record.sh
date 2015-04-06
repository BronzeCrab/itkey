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

# Функция для проверки IP. Сначала регулярным проверяю на то , что все элементы либо цифры 
# либо точки, а затем уже значения октетов, чтобы не было больше 255

function ip_test() {
	temp=""
    ip_valid=0
    if [[ `echo ${IP} | sed 's/\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}//g'` == "" ]]; then
		for (( i=0; i<${#IP}; i++ )); do
		    if [[ ${IP:$i:1} == "." ]]; then
		  		if [[ $temp -gt 255 ]]; then
		  			ip_valid=1
		  		fi
		  		temp=""
		  	elif [[ $i == $[${#IP}-1] ]]; then
		  		temp=$temp${IP:$i:1}
		  		if [[ $temp -gt 255 ]]; then
		  			ip_valid=1
		  		fi
		  	else
		  		temp=$temp${IP:$i:1}			
		  	fi
		done
	else
		ip_valid=1
	fi	
}

ip_test

# Проверка остальных входных параметров 

if [[ $# -lt 3 ]]; then
	echo Слишком мало параметров!
	exit 1
elif [[ ! -f /etc/bind/${DOMAIN}.db ]]; then
	echo Файла c зонами не существует, запись $RECORD не добавлена
	exit 1
elif [[ ip_valid -eq 1 ]]; then
	echo Неправильно введен IP, запись $RECORD не добавлена
	exit 1
fi

if [[ "$MODE" == "1" ]]; then
    if [[ `grep "${RECORD}" /etc/bind/${DOMAIN}.db` != "" ]]; then
    	sed -i 's/'"$RECORD"'//g' /etc/bind/${DOMAIN}.db
    	echo Успешно удалили запись $RECORD
    else
    	echo Не найдена запись $RECORD, не удалена
    fi	
elif [[ "$(cat /etc/bind/${DOMAIN}.db | grep "${RECORD}")" == "" ]]; then
    echo -e $RECORD >> /etc/bind/${DOMAIN}.db
    echo Успешно добавлена запись $RECORD
else
	echo Повтор записи $RECORD, не добавлена
fi

service bind9 restart