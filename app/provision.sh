#!/usr/bin/env bash

if ! command -v java
then
  echo --- install jdk ---
  yum -y install java-11-openjdk java-11-openjdk-devel
  export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
  export PATH=$PATH:$JAVA_HOME/bin 
fi

echo --- setup firewalld ---
systemctl start firewalld
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

echo --- register service ---
cp /vagrant/app/demoapp.service /etc/systemd/system

echo --- start service ---
sudo systemctl daemon-reload
sudo systemctl start demoapp.service

sudo journalctl -u demoapp | grep password

echo --- ssl certificate ---

echo --- restart apache ---
