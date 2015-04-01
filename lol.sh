#!/bin/bash
echo $# arguments
echo cool

if [[ $# < 3 ]]; then
	echo подстава
	exit 0
elif [[ ! -f /home/gr4k/my_scripts/lol.sh ]]; then
	echo file не сущ
else
	echo все ништяк и файл есть
fi
echo end 



var1=$(echo $var1 | sed s/.tar$//)

#Пример использования sed'a
#var1=$(echo $var1 | sed s/.tar$//)	

HOST=10.10.10.10.
if [[ `echo ${HOST} | grep -o "\." | wc -l` != 3 ]]; then 
	echo Неправильно введен ip
	exit 1
fi
