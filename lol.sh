#!/bin/bash

# echo $# arguments
# echo cool

# if [[ $# < 3 ]]; then
# 	echo подстава
# 	exit 0
# elif [[ ! -f /home/gr4k/my_scripts/lol.sh ]]; then
# 	echo file не сущ
# else
# 	echo все ништяк и файл есть
# fi
# echo end 

# Пример использования grep'a для подсчета количества точек

# elif [[ echo ${HOST} | grep -o "\." | wc -l != 3 ]]; then

# var1=$(echo $var1 | sed s/.tar$//)

#Пример использования sed'a
#var1=$(echo $var1 | sed s/.tar$//)	

# Count amount of points

# if [[ `echo ${HOST} | grep -o "\." | wc -l` != 3 ]]; then 
# 	echo Неправильно введен ip 
# 	exit 1
# fi

# How one can use sed
# var1=$(echo $var1 | sed s/.tar$//)

IP=256.256.256.256
a=1
b=2
if [[ `echo ${IP} | sed 's/\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}//'` != "" ]] || \
	[[ a == b ]]; then 
	echo Неправильно введен ip 
	exit 1
fi


# Проверка того, что значения октетов не выше 255

temp=""
ip_valid=0
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