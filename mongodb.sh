#!/bin/bash
DATE=$(date +%x)
USER_ID=$(id)
LOG_FILE=/tmp/$0-$DATE.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
if [ $USER_ID -ne 0 ]
then
    echo -e "$R ERROR..You are not root user $N"
    exit1
fi
VALIDATE(){
    if [$1 -ne 0 ]
    then
        echo -e "$R $2....FAILED.$N"
        exit1
    else    
        echo -e "$G $2....SUCCESSFUL. $N"
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE

VALIDATE $? "copyin gmongo.repo"

yum install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "install mongodb-org"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enable mongod"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOG_FILE
VALIDATE $? "127.0.0.1 to 0.0.0.0 changed"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarting mongod"