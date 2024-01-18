#!/bin/bash

set -x
output log of userdata to /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
ln -s /var/log/user-data.log /home/ubuntu/user-data.log

apt update
apt install apache2 -y
echo "<html><h1>Private Ip: $HOSTNAME</h2></html>" > /var/www/html/index.html
now=$(date)
echo "<html><h1>Creation Time: $now</h2></html>" >> /var/www/html/index.html
