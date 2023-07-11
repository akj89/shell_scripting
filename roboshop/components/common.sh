#!/bin/bash
USERID=$(id -u)

if [ $USERID -ne 0 ] ; then
    echo -e "\e[31m Please run the script with root user or sudo access \e[0m"
fi

stat() {
    if [ $1 -ne 0 ] ; then
        echo -e "\e[31m Failure \e[0m"
    else
        echo -e "\e[32m Success \e[0m"
    fi
}

NODE_JS() {
    echo -n "Downloading nodejs repository:"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
    stat $?

    echo -n "Installing nodejs:"
    yum install nodejs -y  &>> $LOGFILE
    stat $?

    # create user
    CREATE_USER

    # Doenload and extract
    DOWNLOAD_AND_EXTRACT

    # Install npm
    NPM_INSTALL

    # Configure services
    CONFIGURE_SERVICE

    #Start Service
    START_SERVICE

    echo -e "\e[32m _______________$COMPONENT Installation completed_____________\e[0m"
}

CREATE_USER() {
    id $APPUSER &>> $LOGFILE
    if [ $? -ne 0 ]; then
        echo -n "Creating user $APPUSER :"
        useradd $APPUSER &>> $LOGFILE
        stat $?
    fi
}

DOWNLOAD_AND_EXTRACT() {
    echo -n "Downloading the $COMPONENT:"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
    stat $?

    echo -n "Performing cleanup and unzipping the $COMPONENT:"
    rm -rf /home/$APPUSER/$COMPONENT
    cd /home/$APPUSER
    unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE && mv -f $COMPONENT-main $COMPONENT &>> $LOGFILE
    stat $?

    cd /home/$APPUSER/$COMPONENT
    echo -n "Changing permissions to $APPUSER"
    chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT &&  chmod -R 775 /home/$APPUSER/$COMPONENT 
    stat $?
}

CONFIGURE_SERVICE() {
    echo -n "Configuring $COMPONENT file:"
    sed -i -e 's/MONGO_DNSNAME/mongodb.ajrobot.co.uk/' -e 's/CATALOGUE_ENDPOINT/catalogue.ajrobot.co.uk/' -e 's/REDIS_ENDPOINT/redis.ajrobot.co.uk/' -e 's/MONGO_ENDPOINT/mongodb.ajrobot.co.uk/' -e 's/CARTENDPOINT/cart.ajrobot.co.uk/' -e 's/DBHOST/mysql.ajrobot.co.uk/' /home/$APPUSER/$COMPONENT/systemd.service
    stat $?

    mv -f /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
}

START_SERVICE() {
    echo -n "Starting $COMPONENT service:"
    systemctl daemon-reload &>> $LOGFILE
    systemctl start $COMPONENT &>> $LOGFILE
    stat $?
}

MAVEN() {
    echo -n "Installing Maven:"
    yum install maven -y &>> $LOGFILE
    stat $?

    # create user
    CREATE_USER

    # Doenload and extract
    DOWNLOAD_AND_EXTRACT

    # Install Maven
    MVN_INSTALL

    # Configure services
    CONFIGURE_SERVICE

    #Start Service
    START_SERVICE

    echo -e "\e[32m _______________$COMPONENT Installation completed_____________\e[0m"
}

NPM_INSTALL() {
    echo -n "Installing $COMPONENT Dependencies: "
    cd /home/$APPUSER/$COMPONENT
    npm install &>> $LOGFILE
    stat $?
}

MVN_INSTALL() {
    echo -n "Installing $COMPONENT Dependencies: "
    cd /home/$APPUSER/$COMPONENT
    mvn clean package &>> $LOGFILE
    mv target/$COMPONENT-1.0.jar $COMPONENT.jar
    stat $?
}

PYTHON() {
    echo -n "Installing Python: "
    yum install python36 gcc python3-devel -y &>> $LOGFILE
    stat $?

    # create user
    CREATE_USER

    # Doenload and extract
    DOWNLOAD_AND_EXTRACT
}