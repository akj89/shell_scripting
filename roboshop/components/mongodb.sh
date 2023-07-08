#!/bin/bash
set -e

COMPONENT=mongodb
LOGFILE=/tmp/$COMPONENT.log

source components/common.sh

echo -n "Downloading $COMPONENT repository:"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT component:"
yum install -y $COMPONENT-org &>> $LOGFILE
stat $?

echo -n "Downloading $COMPONENT schema:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "Unzipping $COMPONENT schema:"
cd /tmp
unzip $COMPONENT.zip &>> $LOGFILE
cd $COMPONENT-main
mongo < catalogue.js
mongo < users.js

echo -n "Starting $COMPONENT service:"
systemctl daemon-reload
systemctl enable mongod
systemctl start mongod
stat $?