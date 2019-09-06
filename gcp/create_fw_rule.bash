#!/bin/bash

if [ $# -eq 0 ]; then
	echo ""
	echo "    USAGE : one argument missing [firewall name]"
	echo ""
	exit 1
fi

fw_name=$1

my_real_ip=`curl -s ipecho.net/plain; echo`
if [ "${my_real_ip}" == "" ]; then
	my_real_ip='0.0.0.0/0'
fi

echo "fw name    : " $fw_name
echo "my_real_ip : " $my_real_ip

fw_from_cloud=`gcloud compute firewall-rules list --filter="name='${fw_name}'" --format='value(NAME)'`
echo "fw from gcloud : " $fw_from_cloud
echo ""

if [ "$fw_from_cloud" == "" ]; then
	echo "  No Firewall rule for : " $fw_name
	echo "  about to create rule for : " $fw_name
	rc=`gcloud compute firewall-rules create ${fw_name} --action=ALLOW --rules=tcp:6379 --source-ranges=${my_real_ip} --target-tags=${fw_name}`
	echo "    rc from create fw : " $rc
else
	echo "  Found fw rule going to re-create it"
	echo "    About to delete ..."

    rc=`gcloud compute firewall-rules delete ${fw_name} --quiet`
	echo "    rc from delete : " $rc

	rc=`gcloud compute firewall-rules create ${fw_name} --action=ALLOW --rules=tcp:6379 --source-ranges=${my_real_ip} --target-tags=${fw_name}`
	echo "    rc from create fw : " $rc
fi

echo ""
