#!/usr/bin/env bash

# This script runs on
# - vagrant up (only the first time or after destroying the virtual machine)
# - vagrant provision

# avoid ubuntu error bug: stdin: is not a tty
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# execution time start
startTime=$(date +%s)

# debug marker
marker="+ - - - - - - - - - - - - - - - - - - - - - - - - - - - - "$'\r\n|'

echo "${marker} running provision.sh"

echo "| updating apt sources and installing nodejs"
# adding PPA in order to get access to its contents
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs

# The nodejs package contains nodejs and npm
# for some npm packages to work (such as those that require building from source),
# build-essentials package will be installed
echo "${marker} installing build-essential"
sudo apt-get install -y build-essential

echo "${marker} installing bower"
sudo npm install -g bower

echo "${marker} installing grunt global"
sudo npm install -g grunt-cli

echo "${marker} installing git"
apt-get install -y git

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global alias.st status

echo "${marker} installing apache2"
apt-get install -y apache2

echo "${marker} removing html dummy"
rm /var/www/html/index.html

# enable mode rewrite (mod_rewrite)
sudo a2enmod rewrite

# By adding a line here you can enable any configuration file located in
# the vhosts folder belonging to your project.
echo "${marker} enabling vhost"
a2ensite typomachine
# @todo https://

echo "${marker} adding user 'typomachine', groups: www-data"
useradd -G www-data -m -s /bin/bash typomachine

echo "${marker} setting password for user 'typomachine'"
echo "typomachine:typomachine" | chpasswd

echo "${marker} adding user 'dev', groups: vagrant, admin, www-data, typomachine"
useradd -G vagrant,admin,www-data,typomachine -m -s /bin/bash dev

echo "${marker} setting password to dev"
echo "dev:dev" | chpasswd

echo "${marker} adding groups to existing user vagrant: www-data, dev, typomachine"
usermod -a -G www-data,dev,typomachine vagrant

echo "${marker} installing mysql using noninteractive mode"
export DEBIAN_FRONTEND=noninteractive 
apt-get install -q -y mysql-server

echo "${marker} setting password for mysql user root to root"
mysqladmin -u root password root

echo "${marker} creating mysql database typomachine"
mysql -uroot -proot -e "CREATE DATABASE typomachine CHARACTER SET utf8 COLLATE utf8_general_ci;"

echo "${marker} creating mysql user typomachine with password typomachine"
mysql -uroot -proot -e "CREATE USER 'typomachine'@'localhost' IDENTIFIED BY 'typomachine'"

echo "${marker} setting mysql user privileges"
# @todo check privileges 
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON typomachine . * TO 'typomachine'@'localhost'"

echo "${marker} flushing privileges"
mysql -uroot -proot -e "FLUSH PRIVILEGES"

echo "${marker} installing php"
apt-get install -y php5
apt-get install -y php5-mysql
# @todo phpmyadmin reports error
apt-get install -y php5-mcrypt
php5enmod mcrypt
#apt-get install -y libapache2-mod-auth-mysql
#apt-get install -y php5-gd 
#apt-get install -y php-apc
#apt-get install -y php-pear

echo "${marker} modifying php.ini"
upload_max_filesize=10M
post_max_size=10M
max_execution_time=240
for key in upload_max_filesize post_max_size max_execution_time
do
 sudo sed -i "s/^\($key\).*/\1 $(eval echo = \${$key})/" /etc/php5/apache2/php.ini
done

echo "${marker} restarting apache"
apache2ctl restart

echo "${marker} installing additional packages"
apt-get install -y freetype* 
apt-get install -y graphicsmagick

echo "${marker} installing phpMyAdmin"
# Configure the Settings with debconf-set-selections
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
# Install phpmyadmin with noninteractive mode (it will use the set settings)
apt-get install -q -y phpmyadmin

echo "${marker} installing typo3"
cd /var/www
if [ -d typo3_src-6.2.6 ]
  then
    echo "| sourcecode already exists, no action"
    # @todo check md5
  else
    if [ -f 6.2 ]
      then
        echo "| tarball already exists"
      else
        echo "| downnloading tarball (current 6.2.x) ..."
        wget -q http://get.typo3.org/6.2
    fi # /-f 6.2

    echo "| unpacking tarball ..."
    tar -xzf 6.2

###    echo "| deleting tarball"
###    rm 6.2

fi # /-d typo3_src-6.2.6

echo "${marker}| creating symlinks"
cd /var/www/html
ln -s ../typo3_src-6.2.* typo3_src
ln -s typo3_src/index.php index.php
ln -s typo3_src/typo3 typo3



#https://gist.github.com/NamelessCoder/8714035
#cd /var/www
#git clone https://github.com/TYPO3/TYPO3.CMS.git --depth 1 typo3source

#echo "${marker}Open the TYPO3 backend typomachine.local and complete the install wizard"
#echo "Remember: You must add the _cli_lowlevel backend user!"
#read -p "Press any key to continue AFTER you complete the install wizard and create the _cli_lowlevel user"
 
# phase two: extension fetching and installation
#cd /var/www/html
#git clone https://github.com/benjaminkott/bootstrap_package.git --depth 1 typo3conf/ext/bootstrap_package
 
#./typo3/cli_dispatch.phpsh extbase extension:install bootstrap_package
 

echo "${marker} Base setup F I N I S H E D ! " 
echo "${marker} Final steps:"
echo "| - add this line to your /etc/hosts "
echo "|   '192.168.23.23   typomachine.local'"
echo "| - create file FIRST_INSTALL in synced folder htdocs"
echo "| - open http://typomachine.local in your browser and"
echo "| - complete the install wizard (database name, user and password is 'typomachine')"
#      echo "${marker} Maybe you want to start less compilation?"
#      echo "| ssh connect and run" 
#      echo "| /vagrant/www/components/grunt watch" 


# show execution time
finishTime=$(date +%s)
executionTimeSec=$((finishTime - startTime))
executionTime=$(date -u -d @${executionTimeSec} +"%T")
echo "${marker} Execution time: $executionTime hh:mm:ss"
echo "${marker}"
