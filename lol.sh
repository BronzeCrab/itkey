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