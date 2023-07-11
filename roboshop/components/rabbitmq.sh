#!/bin/bash
set -e

COMPONENT=rabbitmq
APPUSER=roboshop
LOGFILE=/tmp/$COMPONENT.log

source components/common.sh

echo -n "Configuring and Installing $COMPONENT:"
curl -s https://packagecloud.io/install/repositories/$COMPONENT/erlang/script.rpm.sh | sudo bash &>> $LOGFILE
curl -s https://packagecloud.io/install/repositories/$COMPONENT/$COMPONENT-server/script.rpm.sh | sudo bash  &>> $LOGFILE
yum install $COMPONENT-server -y  &>> $LOGFILE
stat $?

echo -n "Starting $COMPONENT service:"
systemctl enable $COMPONENT-server  &>> $LOGFILE
systemctl start $COMPONENT-server  &>> $LOGFILE
stat $?


rabbitmqctl list_users | grep $APPUSER &>> $LOGFILE
if [ $? -ne 0 ]; then
    echo -n "Creating application user for $COMPONENT:"
    rabbitmqctl add_user $APPUSER roboshop123  &>> $LOGFILE
    stat $?
fi

echo -n "Granting permission to user for $COMPONENT:"
rabbitmqctl set_user_tags $APPUSER administrator  &>> $LOGFILE
rabbitmqctl set_permissions -p / $APPUSER ".*" ".*" ".*"  &>> $LOGFILE
stat $?

echo -e "\e[32m __________ $COMPONENT Installation Completed _________ \e[0m"