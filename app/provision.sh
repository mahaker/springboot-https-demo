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
firewall-cmd --zone=public --add-port=8443/tcp --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload

echo --- register service ---
cp /vagrant/app/demoapp.service /etc/systemd/system

echo --- start service ---
sudo systemctl daemon-reload
sudo systemctl start demoapp.service

sudo journalctl -u demoapp | grep password

echo --- ssl certificate ---
# keytoolコマンドはホストPCで実行
# keytool -genkeypair -alias demoappkey -keysize 2048 -keyalg RSA -storetype PKCS12 -keystore demoapp.p12 -validity 3650 -keypasswd password001
