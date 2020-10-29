#!/bin/bash

echo '{
"vpc": "",
"account_type": "azure",
"ip_address": "publicIP",
"acc_details":
{
"access_key_id": "",
"secret_key": ""
},
"region": "'$1'",
"iamrole": ""
}
' > /opt/server.init
echo '{
"esinstances": {
"'$2'": "'$3'",
"'$4'": "'$5'",
"'$6'": "'$7'"
},
"eselb": "'$8'"
}
' > /opt/es.json
echo '{
"endpoint": "'$9'",
"db": "snappyflow",
"username": "'${10}'",
"password": "'${11}'"
}
' > /opt/rds.json
export PUBLIC_IP=`curl --silent http://169.254.169.254/latest/meta-data/public-ipv4`
sed -i "s/publicIP/$PUBLIC_IP/g" /opt/server.init
echo "df -Th" >> /opt/resize.log
df -Th >> /opt/resize.log
(
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sdc >> /opt/resize.log

sudo partprobe

pvcreate /dev/sdc1 >> /opt/resize.log

value=$(vgs --noheadings -o vg_name | tr -d '  ')
vgextend $value /dev/sdc1 >> /opt/resize.log

lvextend -l+100%FREE --resizefs /dev/$value/root >> /opt/resize.log
echo "df -Th" >> /opt/resize.log
df -Th >> /opt/resize.log