#!/bin/bash

Private_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
Instance_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do

used=$(echo $output | awk '{ print $1 }' | cut -d'%' -f1)
partition=$(echo $output | awk '{ print $2 }')

if [ "$used" -ge 80 ]; then

aws sns publish \
--region <region> \
--topic-arn <topic-arn> \
--subject "Disk Alert on $Instance_ID" \
--message "$partition is running out of space - $used% full PRIVATE_IP=$Private_IP INSTANCE_ID=$Instance_ID"
fi
done


#crontab -l
#* * * * * /bin/bash /root/Disk-script/Disk-Space-script.sh >>/root/Disk-Space-script.sh/disk-logs.txt 2>&1

#nano /root/Disk-script/Disk-Space-script.sh
