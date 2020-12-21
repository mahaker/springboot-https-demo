#!/usr/bin/env bash

echo --- install jdk ---

yum -y install java-11-openjdk java-11-openjdk-devel
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=\$PATH:\$JAVA_HOME/bin 

echo --- disable firewalld ---

sudo systemctl stop firewalld
