#!/bin/bash
set -e

COMPONENT=catalogue
LOGFILE=/tmp/$COMPONENT.log
APPUSER=roboshop

source components/common.sh


echo -n "Downloading nodejs repository:"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "Installing nodejs:"
yum install nodejs -y  &>> $LOGFILE
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
cd /home/$APPUSER
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "Installing the $COMPONENT dependencies:"
mv $COMPONENT-main $COMPONENT
cd /home/$APPUSER/$COMPONENT
npm install &>> $LOGFILE
stat $?

#$ vim systemd.servce
#mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
#systemctl daemon-reload
#systemctl start $COMPONENT
#systemctl enable $COMPONENT
#systemctl status $COMPONENT -l

