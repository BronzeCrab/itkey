# cat mass_add_dns.sh
#!/bin/bash


#TODO:
# make it work
# add validation
# add error handling

HOSTFILE=$1

for LINE in `cat $HOSTFILE`; do

        HOSTNAME=$(echo $LINE | awk '{print $1}')
        IP=$(echo $LINE | awk '{print $2}')

        DOMAIN=$(echo $HOSTNAME | cut -d'.' -f2-)

        echo $DOMAIN

        #./add_record.sh $HOST $IP $DOMAIN

done