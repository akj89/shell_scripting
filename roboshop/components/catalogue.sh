#!/bin/bash

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

echo -n "Configuring $COMPONENT file:"
sed -i -e 's/MONGO_DNSNAME/172.31.89.38/' /home/$APPUSER/$COMPONENT/systemd.service
stat $?


mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service

echo -n "Starting $COMPONENT service:"
systemctl daemon-reload
systemctl start $COMPONENT
systemctl enable $COMPONENT
stat $?

