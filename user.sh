#!/bin/bash
DATE=$(date +%x-%T)
USER_ID=$(id -u)
USER=$(id roboshop)
#DIRECTORY=$([-d "/app" ])
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ $USER_ID -ne 0 ]
then    
    echo -e "$R ERROR: You are not root user $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 ....FAITURE $N"
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

if [ $USER -ne 0 ]
then
useradd roboshop
else
    echo -e "$Y user roboshop already exits $N"
fi

if [ -d "/app" ]
then
    echo -e "$Y app directory already exist$N"
else
    mkdir /app
fi

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
VALIDATE $? "download zipfile"

cd /app 
VALIDATE $? "changing to app directory"

unzip /tmp/user.zip
VALIDATE $? "unzipping user component"

npm install 
VALIDATE $? "npm install"

cp /home/centos/Shell/user.service /etc/systemd/system/user.service
VALIDATE $? "copying user.service"

systemctl daemon-reload
VALIDATE $? "daemon-reload"

systemctl enable user
VALIDATE $? "enable user"

systemctl start user
VALIDATE $? "start user"

#cp /home/centos/Shell/mongo.repo /etc/yum.repos.d/mongo.repo
cp /home/centos/Shell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo.repo"

yum install mongodb-org-shell -y
VALIDATE $? "install mongodb-org-shell"

mongo --host mongodb.venkateshamsonnalia143.online < /app/schema/user.js
VALIDATE $? "conneting to host"