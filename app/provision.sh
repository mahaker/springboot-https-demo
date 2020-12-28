#!/usr/bin/env bash

if ! command -v java
then
  echo --- install jdk ---
  yum -y install java-11-openjdk java-11-openjdk-devel
  export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
  export PATH=$PATH:$JAVA_HOME/bin 
fi

echo --- install nginx ---
sudo yum -y install nginx
rm /etc/nginx/default.d/app.conf /etc/nginx/nginx.conf
cp /vagrant/app/app.conf /etc/nginx/default.d
cp /vagrant/app/nginx.conf /etc/nginx
mkdir -p /etc/nginx/keys
cp /vagrant/app/dhparam.pem /etc/nginx/keys
cp /vagrant/app/server.crt /etc/nginx/keys
cp /vagrant/app/server.key /etc/nginx/keys
sudo systemctl enable nginx
sudo systemctl start nginx

echo --- setup firewalld ---
systemctl stop firewalld
setenforce 0
# systemctl start firewalld
# firewall-cmd --zone=public --add-port=443/tcp --permanent
# firewall-cmd --zone=public --add-port=8443/tcp --permanent
# firewall-cmd --zone=public  --add-service=https --permanent
# firewall-cmd --reload

echo --- register service ---
cp /vagrant/app/demoapp.service /etc/systemd/system

echo --- start service ---
sudo systemctl daemon-reload
sudo systemctl start demoapp.service

sudo journalctl -u demoapp | grep password
