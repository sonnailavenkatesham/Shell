#!/bin/bash
DATE=$(date +%x-%T)
USER_ID=$(id -u)
USER=$(id roboshop)
DIRECTORY=$([-d "/app"])
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
        echo -e "$R $2....FAILED $N"
        exit 1
    else
        echo -e "$G $2....SUCCESSFULL"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
VALIDATE $? "npm resources"


yum install nodejs -y
VALIDATE $? "install nodejs"

if [ $USER -ne 0 ]
then
    useradd roboshop
else
    echo -e "$Y user roboshop already exist $N"
fi

if [ -d "$DIRECTORY" ] 
then
    echo -e " $Y $DIRECTORY does exist $N"
else
    mkdir /app
fi


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "downloading zip file"

cd /app 
VALIDATE $? "changeing to app Directory"

unzip /tmp/catalogue.zip
VALIDATE $? "unzinping catalogue"

npm install 
VALIDATE $? "npm install "

cp /home/centos/Shell/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "coping catalogue.service"

systemctl daemon-reload
VALIDATE $? "daemon-reload"

systemctl enable catalogue
VALIDATE $? "enable catalogue"

systemctl start catalogue
VALIDATE $? "start catalogue"

cp /home/centos/Shell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo.repo"

yum install mongodb-org-shell -y
VALIDATE $? "install mongodb-org-shell"

mongo --host 18.207.176.168 </app/schema/catalogue.js