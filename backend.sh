#!/bin/bash 

COMPONENT="backend"
LOG="/tmp/backend.log"
APPUSER="expense"
ROOTPASS=$1

source common.sh                # This will pull all the functions and the available variables from this file and make it available locally to this script

COLOR Disabling default nodejs16 version
dnf module disable nodejs -y &>> $LOG
stat $? 

COLOR Enabling Nodejs20
dnf module enable nodejs:20 -y &>> $LOG
stat $? 

COLOR Installing Nodejs20 
dnf install nodejs -y &>> $LOG
stat $? 

id $APPUSER  &>> $LOG                          # This makes sure account creation will only happen if the account doesn't exist.
if [ $? -ne 0 ]; then 
    COLOR Creating $APPUSER Service Account 
    useradd $APPUSER
    stat $? 
fi 

COLOR Cleanup of old content
rm -rf /app &>> $LOG
stat $?

COLOR Downloading $COMPONENT
mkdir /app 
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip    &>> $LOG
stat $? 

COLOR configuring backend service 
cp backend.service /etc/systemd/system/$COMPONENT.service 
stat $?

COLOR Extracting $COMPONENT 
cd /app 
unzip -o /tmp/backend.zip  &>> $LOG
stat $? 

COLOR Generating Artifacts
npm install &>> $LOG
stat $? 

COLOR Defining Permissions To $APPUSER
chmod -R 775 /app
chown -R $APPUSER:$APPUSER /app
stat $? 

COLOR Installing mysql client
dnf install mysql-server -y &>> $LOG
stat $?

COLOR Injecting Scheme To MySQL DB
mysql -h 172.31.46.213 -uroot -p$ROOTPASS < /app/schema/backend.sql  &>> $LOG
stat $? 

COLOR Starting $COMPONENT  
systemctl daemon-reload     &>> $LOG
systemctl enable backend    &>> $LOG
systemctl restart backend     &>> $LOG

echo -e "\n\t ** $COMPONENT Installation Completed **"