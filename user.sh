#!/bin/bash
DATE=$(date +%x-%T)
USER_ID=$(id -u)
USER=$(id roboshop)
DIRECTORY=$([ -d /app ])
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


if [ $USER_ID -ne 0 ]
then    
    echo -e "$R ERROR: You are not root user %N"
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 ....FAITURE $N"
    else
        echo -e "$G $2.....SUCCESSFULL$N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
VALIDATE $? "RPM Node setup"

yum install nodejs -y
VALIDATE $? "install nodejs"

if [ $USER -ne 0 ]
then
    useradd roboshop
else
    echo -e "$Y user roboshop already exits $N"
fi

if [ $DIRECTORY -ne 0 ]
then
    mkdir /app
else
    echo -e "$Y app directory already exist$N"
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

cp home/centos/Shell/monogo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo.repo"

yum install mongodb-org-shell -y
VALIDATE $? "install mongodb-org-shell"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js
VALIDATE $? "conneting to host"