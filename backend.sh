#!/bin/bash

ID=$(id -u)
LOG="/tmp/backend.log"
COMPONENT="backend"
ROOTPASS=$1
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
id $APPUSER &>> LOG
if [ $? -ne 0 ] ; then 
COLOR Creating  $APPUSER Service Accuont
useradd expense  
stat $?
fi

COLOR Cleanup of old  content
rm -rf /app &>> LOG
stat $?

mkdir /app   &>> LOG
stat $?
COLOR Downloading  $COMPONENT
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip   &>> LOG 
stat $?
COLOR configuring  $COMPONENT service
cp $COMPONENT.service  /etc/systemd/system/$COMPONENT.service  
stat $?

COLOR Extracting $COMPONENT
cd /app  
unzip -o /tmp/$COMPONENT.zip   &>> LOG
stat $?

COLOR Genarating Artifacts
npm install  &>> LOG
stat $?
COLOR Defining Permissions To $APPUSER
chmod -R 775 /app
chown -R $APPUSER:$APPUSER /app
stat $?
COLOR Installing mysql client 
dnf install mysql-server -y  &>> LOG
stat $?
COLOR   Injecting Scheme To Myssql  DB
mysql -h 3.86.60.41 -uroot -p$ROOTPASS < /app/schema/backend.sql 
stat $?

COLOR Starting $COMPONENT
systemctl daemon-reload &>> LOG
systemctl enable backend &>> LOG
systemctl start backend &>> LOG
stat $?

echo -e "** $COMPONENT Installation Complated **"