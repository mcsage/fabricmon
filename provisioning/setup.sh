#!/bin/bash

echo "Set hostname"
hostnamectl set-hostname fabricmon

echo "Update and Upgrade"
apt-get update
apt-get upgrade -y

echo "Install required pkgs"
apt-get install -y nginx ibsim-utils
apt-get install -y libopensm5a libibumad3a libibnetdisc5 libopensm5a

apt-get install -y golang
apt-get install -y libibmad-dev libibumad-dev libibnetdisc-dev libopensm-dev

apt-get install -y influxdb influxdb-client
apt-get install -y grafana grafana-data

echo "Doing go stuff"
export GOPATH=/usr/lib/go/
go get -u github.com/influxdata/influxdb/client/v2
go get -u github.com/iansmith/d3

echo "edit configs"
sed -i 's/root \/var\/www\/html\;/root \/vagrant\/webui\;/g' /etc/nginx/sites-available/default
sed -i 's/ubuntu-xenial/fabricmon/g' /etc/hosts

echo "Enable and restart nginx"
systemctl enable nginx.service
systemctl restart nginx.service

echo "You can now reach fabricmon webUI via http://localhost:8080"
