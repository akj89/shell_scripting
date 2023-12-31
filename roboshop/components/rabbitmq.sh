#!/bin/bash 

COMPONENT=rabbitmq
LOGFILE=/tmp/$COMPONENT.log
source components/common.sh

echo -n "Installing and configuring $COMPONENT repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash  &>> $LOGFILE 
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash  &>> $LOGFILE 
stat $? 

echo -n "Installing $COMPONENT : "
yum install rabbitmq-server -y &>> $LOGFILE 
stat $?

echo -n "Starting $COMPONENT :"
systemctl enable rabbitmq-server  &>> $LOGFILE 
systemctl start rabbitmq-server  &>> $LOGFILE 
stat $? 

rabbitmqctl list_users | grep roboshop  &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "Creating Applicaiton user on $COMPONENT: "
    rabbitmqctl add_user roboshop cd &>> $LOGFILE 
    stat $? 
fi 


echo -n "Adding Permissions to $APPUSER :"
rabbitmqctl set_user_tags roboshop administrator &>> $LOGFILE 
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE 
stat $?


echo -e "\e[32m __________ $COMPONENT Installation Completed _________ \e[0m"