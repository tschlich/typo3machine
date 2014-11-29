#!/usr/bin/env bash

# This script runs on every system start

# Apache2 is getting Started before Shared Folders are Mounted by Vagrant
# Simply starts the Apache2 after the init Booting is done.
# avoid ubuntu error bug: stdin: is not a tty
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# execution time start
startTime=$(date +%s)

# debug marker
marker="+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - "$'\r\n|'

echo "${marker} running afterBoot.sh"

# Apache2 is getting Started before Shared Folders are Mounted by Vagrant
# Simply starts the Apache2 after the init Booting is done.
# Runs on every Boot
echo "${marker} start apache2"
apache2ctl start



### Begin Testing ##############################################################




### End Testing ################################################################









# show execution time
finishTime=$(date +%s)
executionTimeSec=$((finishTime - startTime))
executionTime=$(date -u -d @${executionTimeSec} +"%T")
echo "${marker} Execution time: $executionTime hh:mm:ss"
echo "${marker}"
