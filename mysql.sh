#!/bin/bash

ID=$(id -u)
LOG="/tmp/mysql.log"
COMPONENT="Mysql"
ROOTPASS=$1
stat() {
    if [ $1 -eq 0 ] ; then 
    echo -e "\e[35m - Success \e[0m"
else
    echo -e "\e[35m - Failure \e[0m"
    exit 2
fi
}

COLOR(){
    echo -e "\e[31m $* \e[0m"
}
if [ "$ID" -ne 0 ]; then
    echo -e "\e[31m Script is expected  to be  excuted as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi

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