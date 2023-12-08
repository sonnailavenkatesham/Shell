#!/bin/bash
DATE=$(date +%x-%T)
USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USER_NAME=$(id "roboshop")
APP=$(ls "/app")

if [ $USER_ID -ne 0 ]
then
    echo -e "$R ERROR: You are not root user$N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2....FAILED$N"
        exit 1
    else
        echo -e "$G $2.....SUCCESSFULL$N"
    fi
}

dnf module disable nodejs -y
VALIDATE $? "module disable nodejs"

dnf module enable nodejs:18 -y
VALIDATE $? "module enable nodejs:18"

yum install nodejs -y
VALIDATE $? "install nodejs"

if [ $USER_NAME -ne 0 ]
then
    useradd roboshop
else    
    echo -e "$Y user roboshop is already exist $N"
fi

if [ $APP -ne 0 ] 
then
    mkdir /app 
else
    echo -e " $Y /app does exist $N"
fi

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "downloading cart component"

cd /app 
VALIDATE $? "changing to app directory"

unzip /tmp/cart.zip
VALIDATE $? "Unzipping cart component "

cp /home/centos/Shell/cart.service /etc/systemd/system/cart.service

npm install 
VALIDATE $? "npm install"

systemctl daemon-reload
VALIDATE $? "daemon-reload"

systemctl enable cart
VALIDATE $? "enable cart"

systemctl start cart
VALIDATE $? "start cart"
