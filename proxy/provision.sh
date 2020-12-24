#!/usr/bin/env bash

echo --- apache configuration ---
if ! command -v httpd
then
  echo --- install httpd ---
  yum -y install httpd
fi
sudo systemctl enable httpd.service
sudo systemctl start httpd.service

# echo --- setup firewalld ---
sudo systemctl stop firewalld
setenforce 0
