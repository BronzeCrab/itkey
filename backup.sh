#/!bin/bash

# Testing
#var='hello'
#echo $var
# Путь к директории
#/home/gr4k/backup/test1

# Нужно забэкапить что-то используя tar -cf

# Переменная которая хранит имя архива
var1=$1
echo $var1

# Переменная с датой
date_var=$(date +%g%m%d-%H%M) 
echo $date_var

#Изменяю переменную с именем архива
var1=$(echo $var1 | sed s/.tar$//)
# Плохой вариант редактирования подстроки 
# var1="${var1/".tar"/""}"
var1="$var1.$date_var.tar"
echo $var1

# Переменная путь к архиву
var2=$2
echo $var2

tar -cf $var1 $var2