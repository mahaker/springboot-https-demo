#!/usr/bin/env bash

echo --- apache configuration ---
# if ! command -v httpd
# then
  echo --- install httpd ---
  yum -y install httpd
  yum -y install mod_ssl
# fi
rm /etc/httpd/conf/httpd.conf
cp /vagrant/proxy/httpd.conf /etc/httpd/conf
rm /etc/httpd/conf.d/demoproxy.conf
cp /vagrant/proxy/demoproxy.conf /etc/httpd/conf.d
mkdir -p /etc/httpd/keys
cp /vagrant/proxy/server.crt /etc/httpd/keys
cp /vagrant/proxy/server.key /etc/httpd/keys
mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.org
sudo systemctl enable httpd.service
sudo systemctl start httpd.service

echo --- setup testpage ---
mkdir -p /var/www/html/test
cp -r /vagrant/proxy/test/* /var/www/html/test

echo --- setup firewalld ---
sudo systemctl stop firewalld
setenforce 0

# /etc/sysconfig/network-scripts/route-eth1
# 192.168.33.12/24 via 192.168.33.11
