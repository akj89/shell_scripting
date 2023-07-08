
USERID=$(id -u)

if[ $USERID -ne 0 ]; then
    echo -e "\e[31m Please run the script with root user or sudo access \e[0m]"
fi

stat() {
    if[ $1 -ne 0 ]; then
        echo -e "\e[31m Failure \e[0m]"
    else
        echo -e "\e[32m Success \e[0m]"
    fi
}