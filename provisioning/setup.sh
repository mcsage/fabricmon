#!/bin/bash

echo "Set hostname"
hostnamectl set-hostname fabricmon

echo "Update and Upgrade"
apt-get update
apt-get upgrade -y

echo "Install golang and othre dev requirements"
add-apt-repository ppa:longsleep/golang-backports
apt-get update
apt-get install -y golang-go
apt-get install -y libibmad-dev libibumad-dev libibnetdisc-dev libopensm-dev
apt-get install -y libopensm5a libibumad3 libibnetdisc5 libopensm5a

echo "Install required pkgs"
apt-get install -y nginx
apt-get install -y ibsim-utils
apt-get install -y influxdb influxdb-client
apt-get install -y grafana grafana-data

echo "edit configs"
sed -i 's/root \/var\/www\/html\;/root \/vagrant\/webui\;/g' /etc/nginx/sites-available/default
sed -i 's/ubuntu-xenial/fabricmon/g' /etc/hosts

echo "Doing go stuff"
export GOPATH=/home/ubuntu/go/
sudo -u ubuntu -H go get -u github.com/BurntSushi/toml
sudo -u ubuntu -H go get -u github.com/influxdata/influxdb/client/v2

echo "Enable and restart nginx"
systemctl enable nginx.service
systemctl restart nginx.service

echo "Start ibsim"
sudo -u ubuntu -H tmux new -d -s ibsim_and_fabricmon_daemon 'cd /vagrant; LD_PRELOAD=/usr/lib/umad2sim/libumad2sim.so go run *.go; read' \; split-window -d 'cd /vagrant; sudo ibsim -s ibsim.net; read' \;

echo "You can now reach fabricmon webUI via http://localhost:8080"
