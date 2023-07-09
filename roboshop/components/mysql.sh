#!/bin/bash

COMPONENT=mysql
LOGFILE=/tmp/$COMPONENT.log

source components/common.sh

echo -n "Configuring $COMPONENT repo:"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT component:"
yum install mysql-community-server -y &>> $LOGFILE
stat $?

echo -n "Starting $COMPONENT service:"
systemctl enable mysqld && systemctl start mysqld &>> $LOGFILE
stat $?

#echo -n "Changing default password:"
# grep temp /var/log/mysqld.log

