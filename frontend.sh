#!/bin/bash

ID=$(id -u)
LOG="/tmp/frontend.log"
COMPONENT="frontend"
stat() {
    if [ $1 -eq 0 ] ; then 
    echo -e "\e[35m - Success \e[0m"
else
    echo -e "\e[35m - Failure \e[0m"
    exit 1
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

if [ -f proxy.conf] ; then
    COLOR Proxy File Presense
    stat $?
else
    echo -e "\e[31m proxy.conf is not present ,ensure  you supply it \e[0m"
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

COLOR Downloading $COMPONENT 
curl -o /tmp/$COMPONENT.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip &>> LOG
cd /usr/share/nginx/html  &>> LOG
stat $?

COLOR Extracting $COMPONENT 
unzip /tmp/$COMPONENT.zip  &>> LOG
stat $?

COLOR starting $COMPONENT  
systemctl restart nginx  &>> LOG
stat $?

echo "** COMPONENT installation  Is complated **"
