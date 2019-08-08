#!/bin/bash 

if [ $# -eq 0 ]; then
	echo ""
	echo "    USAGE : one argument missing [instance name]"
	echo ""
	exit 1
fi

# gcloud compute instances list --filter="name:docker-1" --format="value(EXTERNAL_IP)"

vm_name=$1

cmd="gcloud compute instances list --filter='name:${vm_name}' --format='value(EXTERNAL_IP)'"
ip=$(eval $cmd)

if [ "$ip" == "" ]; then
	echo ""
	echo "    ERROR : Invalid vm-name : ${vm_name}"
	echo ""
	exit 2
else
	echo "the ip is ${ip}. OK"
	exec ssh $ip
fi 
