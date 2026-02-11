#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python" "nginx" "httpd")

mkdir -p $LOGS_FOLDER # -p is it will check and creates the directory
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" &>>$LOG_FILE
fi

# Validate function takes input as exit status, what command they tried to install
 VALIDATE(){
    if [ $1 -eq 0 ]
    then 
        echo -e "Installing $2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "Installing $2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
        fi
}

for packages in ${PACKAGES[@]}
do
    dnf list installed $packages &>>$LOG_FILE
    if [ $? -ne 0 ]
    then 
        echo "$packages is not installed... going to install it" | tee -a $LOG_FILE
        dnf install $packages -y &>>$LOG_FILE
        VALIDATE $? "$packages"
    else 
        echo -e "Nothing to do $packages... $Y is already installed $N" | tee -a $LOG_FILE
    fi
done