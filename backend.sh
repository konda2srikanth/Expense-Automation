#!/bin/bash

ID=$(id -u)
LOG="/tmp/backend.log"
COMPONENT="backend"
APPUSER="expense"
source comman.sh

COLOR Disable default nodejs16 version
dnf module disable nodejs -y  &>> LOG
stat $?
COLOR enable nodejs20 version
dnf module enable nodejs:20 -y  &>> LOG
stat $?
COLOR installing  nodejs20 version
dnf install nodejs -y  &>> LOG
stat $?
COLOR Creating  $APPUSER Service Accuont
useradd expense  
stat $?
COLOR Cleanup of old  content
rm -rf /app &>> LOG
stat $?

mkdir /app   &>> LOG
stat $?
COLOR Downloading  $COMPONENT
curl -o /tmp/backend.zip https://expense-web-app.s3.amazonaws.com/backend.zip   
stat $?
COLOR configuring  backend service
cp backend.service  /etc/systemd/system/backend.service  
stat $?

COLOR Extracting $COMPONENT
cd /app  
unzip -o /tmp/backend.zip  c
stat $?

COLOR Genarating Artifacts
npm install  &>> LOG
stat $?
COLOR Defining Permissions To $APPUSER
chmod -R 775 /app
chown -R expense:expense /app
stat $?
COLOR Installing mysql client 
dnf install mysql-server -y
stat $?
COLOR   Injecting Scheme To Myssql  DB
mysql -h 3.86.60.41 -uroot -pExpenseApp@1 < /app/schema/backend.sql 
stat $?

COLOR Starting $COMPONENT
systemctl daemon-reload &>> LOG
systemctl enable backend &>> LOG
systemctl start backend &>> LOG
stat $?

echo -e "** $COMPONENT Installation Complated **"