#!/bin/bash
DATE=$(date +%x-%T)
USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USER_ID -ne 0 ]
then
    echo -e "$R ERROR: You are not root user"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2....FAILED$N"
    else
        echo -e "$G....SUCCESSFUL$N"
    fi
}

dnf module disable mysql -y

vim /etc/yum.repos.d/mysql.repo

dnf install mysql-community-server -y

systemctl enable mysqld

systemctl start mysqld

mysql_secure_installation --set-root-pass RoboShop@1

mysql -uroot -pRoboShop@1