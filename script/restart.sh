#!/bin/bash

# A script that restart all the docker containers that were stopped
# You will have to update LOG_FILE and SUMMARY_FILE to matching the desired location
# LOG_FILE will contains one message at each start + when a container is started
# SUMMARY_FILE will only contained messages about container started

# Warning:  Use space before and after [ and ] when using a condition.
# Else the syntax is incorrect

LOG_FILE=/root/scripts/log.txt
SUMMARY_FILE=/root/scripts/summary.txt

echo $(date) : "Script restart.sh launched"
echo $(date) : "Script restart.sh launched"  1>>$LOG_FILE 2>>$LOG_FILE

for container in $(docker container ps -a -q); do

    if [ $(docker container ps -q | grep -e $container | wc -l) == 0 ]
    then
        echo $(date) ": restarting container \"$container\""
        echo $(date) ": restarting container \"$container\"" 1>> $LOG_FILE 2>> $LOG_FILE
        echo $(date) ": restarting container \"$container\"" 1>> $SUMMARY_FILE 2>> $SUMMARY_FILE
        docker container start $container
    fi
done