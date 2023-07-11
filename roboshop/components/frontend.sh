#!/bin/bash
set -e

COMPONENT=frontend
LOGFILE=/tmp/$COMPONENT.log

source components/common.sh

echo -n "Installing nginx: "
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "Downloading $COMPONENT contents:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

cd /usr/share/nginx/html
rm -rf *

echo -n "Unzipping the $COMPONENT contents: "
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
stat $?

mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md &>> $LOGFILE
mv localhost.conf /etc/nginx/default.d/roboshop.conf

for component in catalogue user cart shipping; do
    echo -n "Configuring Reverse Proxy : "
    sed -i -e "/$component/s/localhost/$component.ajrobot.co.uk/"  /etc/nginx/default.d/roboshop.conf 
    stat $?
done

echo -n "Starting $COMPONENT service: "
systemctl enable nginx &>> $LOGFILE
systemctl daemon-reload &>> $LOGFILE
systemctl restart nginx &>> $LOGFILE
stat $?
