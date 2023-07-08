#!/bin/bash
set -e

COMPONENT=catalogue
LOGFILE=/tmp/$COMPONENT.log
APPUSER=roboshop

source components/common.sh


echo -n "Downloading nodejs repository:"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
stat $?

echo -n "Installing nodejs:"
yum install nodejs -y
stat $?


id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ]; then
    echo -n "Creating user $APPUSER :"
    useradd $APPUSER &>> $LOGFILE
    stat $?
fi

echo -n "Downloading the $COMPONENT:"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "Unzipping the $COMPONENT:"
cd /home/roboshop
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "Installing the $COMPONENT dependencies:"
mv $COMPONENT-main $COMPONENT
cd /home/roboshop/$COMPONENT
npm install &>> $LOGFILE
stat $?

#$ vim systemd.servce
#mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
#systemctl daemon-reload
#systemctl start catalogue
#systemctl enable catalogue
#systemctl status catalogue -l

