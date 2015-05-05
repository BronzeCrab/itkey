#!/bin/bash

#Configuration file for this script

source backup.conf

# Check for conf file

# echo $PATH_TO_SERVER_FOLDER
# echo $AMOUNT_OF_COPIES
# echo $SERVER_IP

# Check for conf file

if [[ $PATH_TO_SERVER_FOLDER == "" ]] ||\
   [[ $AMOUNT_OF_COPIES == "" ]] ||\
   [[ $SERVER_IP == "" ]] ||\
   [[ $WHICH_DIR_TO_BACKUP == "" ]] ||\
   [[ $NAME_OF_BACKUP_FILE == "" ]]
	then
		echo "not enough parameters"
fi

#Connect to NFS server
mount $SERVER_IP:$PATH_TO_SERVER_FOLDER ~/data
#Cd to sharing dir
cd ~/data
#Setting up date variable
date_var=$(date +%g%m%d-%H%M)
#Use tar to make tarball in sharing dir
tar -cf $NAME_OF_BACKUP_FILE$date_var.tar $WHICH_DIR_TO_BACKUP
#Logging into /var/log/mylog file
if [[ `echo $?` -eq 0 ]]; then
	echo " `date` --- Sucsessfully create tar of ">>/var/log/mylog
else
	echo " `date` --- Error during tar">>/var/log/mylog
fi

# Checking if there too much tar files (> than AMOUNT_OF_COPIES)

number_of_cur_copies=${ls | grep "^$NAME_OF_BACKUP_FILE" | wc -w}

if [[ $number_of_cur_copies -gt $AMOUNT_OF_COPIES ]]; then
	how_much_to_del=${expr $number_of_cur_copies - $AMOUNT_OF_COPIES}
	#ls -t - sort by time then take tail and del
	ls -t | tail -$how_much_to_del | xargs rm -r
fi

