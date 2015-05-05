#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo Too few arguments, aborting
    echo "usage: $? NETWORK_ID_TO_DEL"
    exit 1
fi

NETWORK_ID_TO_DEL=$1
# ROUTER_ID=$2

# initialize neutron
source openrc
# get subnet_id
SUBNET_ID=$(neutron net-show -f value -F subnets $NETWORK_ID_TO_DEL)
# get list of id's of ports in json format for further pasring
ports_id_list=$(neutron port-list --network-id=$NETWORK_ID_TO_DEL --field id --request-format json -f json)
# iterating through all port_ids and deleting them  
for port_id in $(echo $ports_id_list | grep -Po '(?<="id":\s")[a-z0-9-]*'); do
    neutron port-delete $port_id
    if [[ `echo $?` -eq 0 ]]; then
        echo "Port was successfully deleted: "$port_id
    else
        # If one can't delete port it's all about it is connected to the router
        port_id_to_router=$port_id
    fi
done
# it is possible to figure out what router is serving that port_id_to_router
echo "Port $port_id_to_router wasn't deleted, something went wrong" 
echo "It is possible that that port is connected to router, will check this"
# one can get fixed_ips from port,then it is possible to ger ip_address from that stuff
fixed_ips=$(neutron port-show -f value -F fixed_ips $port_id_to_router)
    # echo "Try to check fixed"
    # echo $fixed_ips
# in fixed_ips now should be something like that: {"subnet_id": "96550829-cc98-49e2-a5d0-df4d8bb25f0d", "ip_address": "10.0.24.1"}
# now one can get ip_address from fixed_ips
ip_address=$(echo $fixed_ips | grep -Po '(?<="ip_address":\s")[0-9\.]*')
    # echo "Try to check ip address"
    # echo $ip_address
# Now we have ip of the port, then I try to get the list of ids of all routers
routers_id_list=$(neutron router-list -f json --request-format json -F id)
    # echo "Try to check routers_list"
    # echo $routers_id_list
# Iterating through each router in the list above
for router_id in $(echo $routers_id_list | grep -Po '(?<="id":\s")[a-z0-9-]*'); do
    # we can see each router's parameters, i use the same var fixed_ips cause old value is already parsed and
    # i don't need it already 
    fixed_ips=$(neutron router-port-list -f json --request-format json -F fixed_ips $router_id)
        # echo "Try to check fixed_ips of router"
        # echo $fixed_ips
    # now in fixed_ips should be something like this:
    # [{"fixed_ips": "{\"subnet_id\": \"8cf51b9f-7f88-46d3-b931-6664aa781c83\", \"ip_address\": \"192.168.111.1\"}"},
    #  {"fixed_ips": "{\"subnet_id\": \"d4725b6d-c1e0-43da-b176-c1e7369b39ac\", \"ip_address\": \"10.4.162.220\"}"}]
    ip_addresses_in_router=$(echo $fixed_ips | grep -Po '(?<="ip_address\\\":\s\\\")[0-9\.]*')
        # echo "Try to check ip_addresses of router"
        # echo $ip_addresses_in_router
    for ip in $ip_addresses_in_router; do
            # echo "Try to check ip in ip_addresses_in_router of router"
            # echo $ip
        if [[ $ip == $ip_address ]]; then
                # echo "Ips are equal"
            neutron router-interface-delete $router_id $SUBNET_ID
            if [[ `echo $?` -eq 0 ]]; then
                echo "Interface was successfully deleted from router with id "$router_id
            else
                echo "Something went wrong, interface wasn't deleted from router with id "$router_id
            fi
        fi  
    done
done

# ==old==

# del interface on router old variant 
# neutron router-interface-delete $ROUTER_ID $SUBNET_ID

# ==old==

# it is neccessary to know environment name to del security group
env_name=$(neutron net-show -f value -F name $NETWORK_ID_TO_DEL | rev | cut -d'-' -f2- | rev)

# del whole network
neutron net-delete $NETWORK_ID_TO_DEL
if [[ `echo $?` -eq 0 ]]; then
            echo "Network $NETWORK_ID_TO_DEL has been successfully deleted"
else
    echo "Something went wrong, network $NETWORK_ID_TO_DEL wasn't deleted"
fi

# got env_name, now grab names of security groups
names_of_groups=$(neutron security-group-list -f json --request-format json -F name | grep -Po '(?<="name":\s")[a-zA-Z0-9-_]*')
# [{"name": "murano-dbafwi98vpnrv1-MuranoSecurityGroup-quick-env-14-br6bn6ioakq6"}, {"name": "murano-gjmvli92nv5t4q-MuranoSecurityGroup-test_5-avjjilxccwkx"},]
for name in $names_of_groups; do
    if [[ $name =~ $env_name ]]; then
        # echo "Try to check name of security group"
        # echo $name
        neutron security-group-delete $name
        if [[ `echo $?` -eq 0 ]]; then
            echo "Security group with name $name was successfully deleted"
        else
            echo "Something went wrong, security group with name $name wasn't deleted"
        fi
    fi  
done