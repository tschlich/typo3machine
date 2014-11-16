#!/bin/bash

echo "### Paketquellen aktualisieren:"
apt-get update

echo "### Apache installieren:"
apt-get install -y apache2

# Eintrag in der hosts-Datei des Hostsystems nicht vergessen!
echo "### Aktiviere vhost"
a2ensite thosh-t3dist
# @todo SSL https://

echo "### index.html löschen"
rm /var/www/html/index.html

echo "### Installiere MySQL"
# Setting the noninteractive Mode
export DEBIAN_FRONTEND=noninteractive
# Installs MySQL in noninteractive Mode 
apt-get install -q -y mysql-server
# Set Password for user "root" to root
# @todo - Development/Production
mysqladmin -u root password root



echo "### PHP5 installieren"
apt-get install -y php5
#apt-get install -y libapache2-mod-auth-mysql
apt-get install -y php5-mysql
# Wird für phpMyAdmin benötigt
apt-get install -y php5-mcrypt
#apt-get install -y php5-gd 
#apt-get install -y php-apc
#apt-get install -y php-pear

echo "### Webserver neu starten"
apache2ctl restart

echo "### Weitere Programme installieren"
apt-get install -y freetype* 
apt-get install -y git
apt-get install -y graphicsmagick

echo "### Installiere PhpMyAdmin"
# Configure the Settings with debconf-set-selections
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
# Install phpmyadmin with noninteractive mode (it will use the set settings)
apt-get install -q -y phpmyadmin
