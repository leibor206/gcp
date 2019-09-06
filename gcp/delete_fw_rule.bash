#!/bin/bash

if [ $# -eq 0 ]; then
	echo ""
	echo "    USAGE : one argument missing [firewall name]"
	echo ""
	exit 1
fi

fw_name=$1

echo "fw name    : " $fw_name

fw_from_cloud=`gcloud compute firewall-rules list --filter="name='${fw_name}'" --format='value(NAME)'`
echo "fw from gcloud : " $fw_from_cloud
echo ""

if [ "$fw_from_cloud" == "" ]; then
	echo "  No Firewall rule for : " $fw_name
else
	echo "  Found fw rule going to re-create it"
	echo "    About to delete ..."

    rc=`gcloud compute firewall-rules delete ${fw_name} --quiet`
	echo "    rc from delete : " $rc
fi

echo ""
