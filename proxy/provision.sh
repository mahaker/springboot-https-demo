#!/usr/bin/env bash

echo --- apache configuration ---
yum -y install httpd
# rm -rf /etc/httpd/conf.d/
# cp /vagrant/proxy/httpd.conf /etc/httpd/conf/
sudo systemctl enable httpd.service
sudo systemctl start httpd.service

# echo --- setup firewalld ---
sudo systemctl stop firewalld
setenforce 0
