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
"username": "'$10'",
"password": "'$11'"
}
' > /opt/rds.json
export PUBLIC_IP=`curl --silent http://169.254.169.254/latest/meta-data/public-ipv4`
sed -i "s/publicIP/$PUBLIC_IP/g" /opt/server.init
echo "df -Th" >> /opt/resize.log
df -Th >> /opt/resize.log
echo "lsblk" >> /opt/resize.log
lsblk >> /opt/resize.log
echo "growpart /dev/nvme0n1 2" >> /opt/resize.log
growpart /dev/nvme0n1 2 >> /opt/resize.log
echo "lsblk" >> /opt/resize.log
lsblk >> /opt/resize.log
echo "pvresize /dev/nvme0n1p2" >> /opt/resize.log
pvresize /dev/nvme0n1p2 >> /opt/resize.log
echo "lvextend -l +100%FREE /dev/mapper/centos-root" >> /opt/resize.log
lvextend -l +100%FREE /dev/mapper/centos-root >> /opt/resize.log
echo "xfs_growfs /dev/centos/root" >> /opt/resize.log
xfs_growfs /dev/centos/root >> /opt/resize.log
echo "df -Th" >> /opt/resize.log
df -Th >> /opt/resize.log