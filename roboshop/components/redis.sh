#!/bin/bash
set -e

COMPONENT=redis
LOGFILE=/tmp/$COMPONENT.log

source components/common.sh

echo -n "Downloading $COMPONENT repository:"
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo  &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT:"
yum install $COMPONENT-6.2.11 -y  &>> $LOGFILE
stat $?

echo -n "Configuring $COMPONENT file:"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/$COMPONENT/$COMPONENT.conf

echo -n "Starting $COMPONENT service:"
systemctl daemon-reload &>> $LOGFILE
systemctl enable $COMPONENT  &>> $LOGFILE
systemctl start $COMPONENT  &>> $LOGFILE
stat $?
