#!/bin/bash

ID=$(id -u)
LOG="/tmp/frontend.log"

stat() {
    if [ $1 -eq 0 ] ; then 
    echo -e "\e[35m - Success \e[0m"
else
    echo -e "\e[35m - SFailure \e[0m"
fi
}

COLOR(){
    echo -e "\e[33m $* \e[0m"
}
if [ "$ID" -ne 0 ]; then
    echo -e "\e[31m Script is expected  to be  excuted as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi

COLOR Installing Nginx
dnf install nginx -y   &>> LOG
stat $?

COLOR Copying Proxy file 
cp proxy.conf /etc/nginx/default.d/expense.conf    
stat $?

COLOR Enabling Nginx 
systemctl enable nginx  &>> LOG
stat $?

COLOR Performing Cleanup 
rm -rf /usr/share/nginx/html/*  &>> LOG
stat $?

COLOR Downloading Frontend 
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> LOG
cd /usr/share/nginx/html  &>> LOG
stat $?

COLOR Extracting Frontend 
unzip /tmp/frontend.zip  &>> LOG
stat $?

COLOR starting Frontend 
systemctl restart nginx  &>> LOG
stat $?

echo "** Frontend installation  Is complated **"
