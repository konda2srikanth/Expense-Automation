#!/bin/bash

ID=$(id -u)
LOG="/tmp/mysql.log"
COMPONENT="Mysql"
ROOTPASS=$1

source comman.sh

COLOR installing $COMPONENT
dnf install mysql-server -y &>> LOG
stat $?
COLOR Enabling $COMPONENT
systemctl enable mysqld     &>> LOG
stat $?
COLOR Starting $COMPONENT
systemctl start  mysqld     &>> LOG
stat $?
COLOR Configuring  $COMPONENT Root password
mysql_secure_installation --set-root-pass $ROOTPASS   &>> LOG
stat $?

echo -e "** $COMPONENT Installation Complated **"