#!/bin/bash
DATE=$(date +%x-%T)
USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
USER=$(id roboshop)

if [ $USER_ID -ne 0 ]
then
    echo -e "$R ERROR: You are not root user$N"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2....FAILED$N"
    else
        echo -e "$G $2.....SUCCESSFULL$N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
VALIDATE $? "Downloading npm setup"

yum install nodejs -y
VALIDATE $? "install nodejs"

if [ $USER -ne 0 ]
then
    adduser roboshop
else
    echo -e "$Y user roboshop already exists$N"
fi

if [ -d "/app" ]
then    
    echo -e "$R/app directory already exist$N"
else
    mkdir /app
fi

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "downloading cart component"

cd /app 
VALIDATE $? "changing to app directory"

unzip /tmp/cart.zip
VALIDATE $? "Unzipping cart component "

npm install 
VALIDATE $? "npm install"

systemctl daemon-reload
VALIDATE $? "daemon-reload"

systemctl enable cart
VALIDATE $? "enable cart"

systemctl start cart
VALIDATE $? "start cart"
