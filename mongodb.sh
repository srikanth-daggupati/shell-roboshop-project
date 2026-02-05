#!/bin/bash
USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

mkdir -p $LOGS_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e $2 ...$R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e $2 ...$G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}
 
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongodb Repo"

dnf install mongodb-org -y 
VALIDATE $? "Installing MongoDB server"

systemctl enable mongod
VALIDATE $? "Enabling MongoDB"

systemctl start mongod 
VALIDATE $? "Start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongodb.conf
VALIDATE $? "Allowing Remote connections"

systemctl restart mongod
VALIDATE $? "Restarted MongoDB"