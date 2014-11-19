#!/bin/bash

# execution time start
startTime=$(date +%s)

# speed up provisioning for development
flagInstalled="/var/www/flagInstalled"
if [ -f $flagInstalled ]
  then
    echo "System wurde bereits installiert"
  else
    echo "Starte Installation: thosh-t3dist"
    touch $flagInstalled

    echo "### Paketquellen aktualisieren:"
    apt-get update

    echo "### Apache installieren:"
    apt-get install -y apache2

    echo "### entferne html-Dummy"
    rm /var/www/html/index.html

    # Eintrag in der hosts-Datei des Hostsystems nicht vergessen!
    echo "### Aktiviere vhost"
    a2ensite thosh-t3dist
    # @todo SSL https://

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

    echo "### Installiere Typo3"
    cd /vagrant
    if [ -d typo3_src-6.2.6 ]
      then
        echo "Typo3-Quellcode vorhanden"
        # @todo check md5 or similar
      else
        echo "### Lade Typo3-Paket (current 6.2) ..."
        wget -q http://get.typo3.org/6.2
        echo "### Entpacke Typo3-Paket ..."
        tar -xzf 6.2
        rm 6.2
    fi

    echo "### Erstelle Symlinks"
    cd /vagrant/html
    ln -s ../typo3_src-6.2.* typo3_src
    ln -s typo3_src/index.php index.php
    ln -s typo3_src/typo3 typo3
    # Datei .htaccess bereitstellen wenn nicht vorhanden
    if [ -f .htaccess ]
      then
        echo ".htaccess bereits vorhanden"
      else
        echo ".htaccess bereitstellen"
        cp typo3_src/_.htaccess .htaccess
    fi

    echo "### User Configuration"
    # Adding User dev and make him member of the Groups vagrant and admin
    useradd -G vagrant,admin,www-data -m -s /bin/bash dev

    # change password of user dev to dev
    echo "dev:dev" | chpasswd

    #  Adding existing user vagrant to group www-data
    usermod -a -G www-data vagrant
# @todo check rights
#    chown -R www-data:www-data /var/www
#    chmod -R ugo-rwx /var/www
#    chmod -R ug+rwX /var/www
chown -R www-data:www-data /var/www/html
chmod -R ugo-rwx /var/www/html
chmod -R ug+rwX /var/www/html

    echo "### Erstelle symlinks für Benutzer"
    ln -s /vagrant /home/vagrant/vagrantFolder
    ln -s /vagrant /home/dev/vagrantFolder

    echo "### Installing nodejs"
    # install PPA in order to get access to its contents
    curl -sL https://deb.nodesource.com/setup | sudo bash -

    # The PPA will be added to your configuration and your local package cache 
    # will be updated automatically. 
    # After running the setup script from nodesource, you can install the Node.js
    # package in the same way that you did above
    sudo apt-get install -y nodejs

    # The nodejs package contains the nodejs binary as well as npm, so you don't 
    # need to install npm separately. 
    # However, in order for some npm packages to work (such as those that require 
    # building from source), you will need to install the build-essentials package:
    sudo apt-get install -y build-essential

    echo "### Installing Bower Web Package Manager" 
    npm install -g bower

fi


# start testing

cd /var/www/html

# @todo Problems with group rights,  on OSX the shared folder on the host needs 
# to get fixed after every bower package install in bower_components
# admin rights seems to be ok for store in vagrantFolder (see t3source)
echo "### loading jQuery" 
sudo -H -u dev bower install jquery

echo "###  Loading Twitter Bootstrap Framework" 
#sudo -H -u dev bower install bootstrap

echo "###  Loading Twitter Bootstrap Framework" 
#sudo -H -u dev bower install modernizr

# end testing 
echo "### Installation/Provisioning finished"
finishTime=$(date +%s)
executionTimeSec=$((finishTime - startTime))
executionTime=$(date -u -d @${executionTimeSec} +"%T")
echo "Execution time: $executionTime hh:mm:ss"