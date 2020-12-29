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
rm /etc/nginx/conf.d/app.conf /etc/nginx/nginx.conf
cp /vagrant/app/app.conf /etc/nginx/conf.d
cp /vagrant/app/nginx.conf /etc/nginx
mkdir -p /etc/nginx/keys
cp /vagrant/app/dhparam.pem /etc/nginx/keys
cp /vagrant/app/server.crt /etc/nginx/keys
cp /vagrant/app/server.key /etc/nginx/keys
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl restart nginx

echo --- setup postgres ---
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf -qy module disable postgresql
sudo dnf install -y postgresql10-server
sudo /usr/pgsql-10/bin/postgresql-10-setup initdb
sudo systemctl enable postgresql-10
sudo systemctl start postgresql-10
sudo systemctl restart postgresql-10
sudo su - -c 'psql -U postgres -f /vagrant/app/init.sql' postgres
sudo su - -c 'psql -U postgres -d mydb -f /vagrant/app/tables.sql' postgres

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
sudo systemctl restart demoapp.service

sudo journalctl -u demoapp | grep password
