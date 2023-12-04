#!/bin/bash
DATE=$(date +%x-%T)
USER_ID=$(id -u)
R="\e[31m"
G="\e[31m"
Y="\e[31m"
N="\e[31m"
if [ $USER_ID -ne 0 ]
then    
    echo -e "$R ERROR: You are not user $N"
fi
VALIDATE(){
    if [ $1 -ne 0 ]
    then    
        echo -e "$R $2....FAILED"
    else
        echo -e "$G $2....SUCCESFULL"
    fi
}

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "rpms -setup"

yum module enable redis:remi-6.2 -y
VALIDATE $? "module enable redis:remi-6.2"

yum install redis -y 
VALIDATE $? "install redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf
VALIDATE $? "changing 127.0.0.1 to 0.0.0.0"

systemctl enable redis
VALIDATE $? "enable redis"

systemctl start redis
VALIDATE $? "start redis"