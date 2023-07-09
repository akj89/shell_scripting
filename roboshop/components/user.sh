#!/bin/bash

COMPONENT=user
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
rm -rf /home/$APPUSER/$COMPONENT
cd /home/$APPUSER
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE && mv -f $COMPONENT-main $COMPONENT &>> $LOGFILE
stat $?

cd /home/$APPUSER/$COMPONENT
echo -n "Changing permissions to $APPUSER"
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT &&  chmod -R 775 /home/$APPUSER/$COMPONENT 
stat $?

echo -n "Installing the $COMPONENT dependencies:"
npm install &>> $LOGFILE
stat $?

echo -n "Configuring $COMPONENT file:"
sed -i -e 's/MONGO_ENDPOINT/mongodb.ajrobot.co.uk/' -e 's/REDIS_ENDPOINT/redis.ajrobot.co.uk/' /home/$APPUSER/$COMPONENT/systemd.service
stat $?


mv -f /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service

echo -n "Starting $COMPONENT service:"
systemctl daemon-reload &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
systemctl restart $COMPONENT &>> $LOGFILE
stat $?

echo -e "\e[32m _______________$COMPONENT Installation completed_____________\e[0m"

