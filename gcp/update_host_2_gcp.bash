#!/bin/bash 

tmp_id=`id -u`
echo "user id :"$tmp_id
if [ $tmp_id -ne 0 ]; then
	echo ""
	echo "  the script needs to run as root"
	echo ""
fi

HOSTS_FILE=/etc/hosts

# build yyyy_mm_dd as extention for backup
curr_date=`date +%Y_%m_%d`
echo "cur date:"$curr_date

# backup the current hosts file
sudo cp -f $HOSTS_FILE $HOSTS_FILE.${curr_date}
rc=$?
echo "rc from copy : "$rc
if [ $rc -ne 0 ]; then
	echo ""
	echo "   ERROR : cannot backup file : ${HOSTS_FILE}"
	echo ""
	exit $rc
fi

# get hostname+ip in csv format without header
tmp_str=`gcloud compute instances list --format="csv[no-heading](NAME,EXTERNAL_IP)"`
echo $tmp_str

# array to hold : host,ip
hosts_and_ips=$(echo $tmp_str | tr " " "\n")

for pair in $hosts_and_ips
do
	echo " - "$pair

	# get the two parts
	tmp_host=$(echo ${pair} | cut -d, -f1)
	tmp_ip=$(echo ${pair} | cut -d, -f2)

	# get the fqdn
	tmp_fqdn=`ssh \-o StrictHostKeyChecking=no ${tmp_ip} hostname \-A`

	# build the new line
	tmp_new_line=$tmp_ip" "$tmp_fqdn" "$tmp_host
	echo "new line : "  $tmp_new_line 
	echo ""	
	
	# delete rows with older record
	eval sudo sed -i ${curr_date} '/${tmp_host}.*/d' ${HOSTS_FILE}

	# add the new record
	echo $tmp_new_line | sudo tee -a $HOSTS_FILE > /dev/null
done

