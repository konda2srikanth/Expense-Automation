#!/bin/bash 

COMPONENT="mysql"
ROOTPASS=$1
LOG="/tmp/mysql.log"

source common.sh                # This will pull all the functions and the available variables from this file and make it available locally to this script

COLOR Installing $COMPONENT
dnf install mysql-server -y  &>> $LOG
stat $?

COLOR Enabling $COMPONENT
systemctl enable mysqld       &>> $LOG
stat $?

COLOR Starting $COMPONENT 
systemctl start  mysqld       &>> $LOG      
stat $?

COLOR Configuring $COMPONENT Root Password
mysql_secure_installation --set-root-pass $ROOTPASS  &>> $LOG      
stat $?

echo -e "\n\t ** $COMPOMENT Installation Completed **"