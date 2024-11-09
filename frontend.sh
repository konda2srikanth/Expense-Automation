#!/bin/bash

ID=$(id -u)

if [ "$ID" -ne 0]; then
    echo -e "\e[31m Script is expected  to be  excuted as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi
echo "installing Nginx"
dnf install nginx -y  
echo "Copying Proxy file"
cp proxy.conf /etc/nginx/default.d/expense.conf
echo "Enabling Nginx"
systemctl enable nginx 
echo "Performing Cleanup"
rm -rf /usr/share/nginx/html/*  
echo "Downloading Frontend"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html 
echo "Extracting Frontend"
unzip /tmp/frontend.zip
echo "starting Frontend"
systemctl restart nginx 
echo "** Frontend installation  Is complated **"
