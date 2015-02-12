#!/usr/bin/env bash

# This script runs on every system start

# avoid ubuntu error bug: stdin: is not a tty
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# execution time start
startTime=$(date +%s)

# debug marker
marker="+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - "$'\r\n|'

echo "${marker} running afterBoot.sh"

# Apache2 is getting started before shared folders are being mounted by Vagrant
# Simply starts the Apache2 after the init Booting is done.
echo "${marker} start apache2"
apache2ctl start

BUFOLDER=/vagrant/MySQL_Backups;
if [ -d $BUFOLDER ]
  then
    NOW=$(date +"%Y-%m-%d_%H-%M-%S")
    BUFILE="DB_$NOW.sql"
    echo "${marker} Creating database backup: $BUFOLDER/$BUFILE";
    mysqldump -u typomachine -ptypomachine typomachine > $BUFOLDER/$BUFILE 
  else
    echo "${marker} Creating database backup folder: $BUFOLDER";
    mkdir $BUFOLDER
fi # /-d $BUFOLDER

# show execution time
finishTime=$(date +%s)
executionTimeSec=$((finishTime - startTime))
executionTime=$(date -u -d @${executionTimeSec} +"%T")
echo "${marker} Execution time: $executionTime hh:mm:ss"
echo "${marker}"
