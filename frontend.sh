#!/bin/bash

ID=$(id -u)

if [ "$ID" -ne 0 ]; then
    echo -e "\e[31m Script is expected  to be  excuted as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi

echo -e "\e[31m installing Nginx \e[0m"
dnf install nginx -y   &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[31m - Success \e[0m"
else
    echo -e "\e[31m - SFailure \e[0m"
fi

echo  -e "\e[31m Copying Proxy file \e[0m"
cp proxy.conf /etc/nginx/default.d/expense.conf    
if [ $? -eq 0 ] ; then 
    echo -e "\e[31m - Success \e[0m"
else
    echo -e "\e[31m - SFailure \e[0m"
fi

echo -e "\e[31m Enabling Nginx \e[0m"
systemctl enable nginx  &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[31m - Success \e[0m"
else
    echo -e "\e[31m - SFailure \e[0m"
fi

echo -e "\e[31m Performing Cleanup \e[0m"
rm -rf /usr/share/nginx/html/*  &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[31m - Success \e[0m"
else
    echo -e "\e[31m - SFailure \e[0m"
fi

echo -e "\e[31m Downloading Frontend \e[0m"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> /tmp/frontend.log
cd /usr/share/nginx/html  &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[31m - Success \e[0m"
else
    echo -e "\e[31m - SFailure \e[0m"
fi

echo -e "\e[31m Extracting Frontend \e[0m"
unzip /tmp/frontend.zip  &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[31m - Success \e[0m"
else
    echo -e "\e[31m - SFailure \e[0m"
fi

echo -e "\e[31m starting Frontend \e[0m"
systemctl restart nginx  &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then 
    echo -e "\e[31m - Success \e[0m"
else
    echo -e "\e[31m - SFailure \e[0m"
fi

echo "** Frontend installation  Is complated **"
