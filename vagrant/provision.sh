#!/bin/bash

# execution time start
startTime=$(date +%s)

### !! IMPORTANT !! ############################################################
# set development false to avoid data loss
# also set development false on first vm start when developing
# @todo - Development/Production, split to different provisioners like:
### entire project installation
# 1. install   provision.sh          # local changes will be lost!
### partial provisioners
# 2. database  provision_database.sh # database only, think about migrations
# 3. media     provision_media.sh    # media only, like images, videos, pdfiles
# 4. layout    provision_layout.sh   # layout only, html, css, less, 
# ...                                # tbc... 
# e.g. $ vagrant provision --provision-with media
# see https://docs.vagrantup.com/v2/cli/provision.html
development=true

# speed up provisioning for development 
# @todo - remove when different provisioners are implemented
flagInstalled="/home/vagrant/flagInstalled"
if [ -f $flagInstalled ]
  then
    echo "### system allready started"
  else
    echo "### start project installation"
    # remove linebreak when not developing on vagrant>>    touch $flagInstalled #<<

    if [ "$development" = false ] ; then

      echo "### update package sources"
      apt-get update

      #echo "### install git"
      #apt-get install -y git

      echo "### install apache2"
      apt-get install -y apache2

      echo "### remove html dummy"
      rm /var/www/html/index.html

      echo "### enable vhost"
      a2ensite thosh-t3dist
      # @todo https://

      echo "### add user dev, group member of vagrant, admin and www-data"
      useradd -G vagrant,admin,www-data -m -s /bin/bash dev

      echo "### change user password to dev"
      echo "dev:dev" | chpasswd

      #echo "### add existing user vagrant to group www-data"
      #usermod -a -G www-data vagrant

      echo "### install mysql using noninteractive mode"
      export DEBIAN_FRONTEND=noninteractive 
      apt-get install -q -y mysql-server

      echo "### set password for user root to root"
      mysqladmin -u root password root

      echo "### create user t3dist with password t3dist"
      mysql -uroot -proot -e "CREATE USER 't3dist'@'localhost' IDENTIFIED BY 't3dist'"

      echo "### create database t3dist"
      mysql -uroot -proot -e "CREATE DATABASE t3dist CHARACTER SET utf8 COLLATE utf8_general_ci;"

      echo "### set t3dist privileges"
      # @todo check privileges 
      mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON t3dist . * TO 't3dist'@'localhost'"

      echo "### flush privileges"
      mysql -uroot -proot -e "FLUSH PRIVILEGES"

      echo "### install php"
      apt-get install -y php5
      apt-get install -y php5-mysql
      apt-get install -y php5-mcrypt
      #apt-get install -y libapache2-mod-auth-mysql
      #apt-get install -y php5-gd 
      #apt-get install -y php-apc
      #apt-get install -y php-pear

      echo "### restart apache"
      apache2ctl restart

      echo "### install additional packages"
      apt-get install -y freetype* 
      apt-get install -y graphicsmagick

      echo "### install phpMyAdmin"
      # Configure the Settings with debconf-set-selections
      echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
      # Install phpmyadmin with noninteractive mode (it will use the set settings)
      apt-get install -q -y phpmyadmin

      echo "### install typo3"
      cd /var/www
      if [ -d typo3_src-6.2.6 ]
        then
          echo "### sourcecode exists, no action"
          # @todo check md5
        else
          if [ -f 6.2 ]
            then
              echo "### tarball exists, unpack ..."
            else
              echo "### load tarball (current 6.2.x) ..."
              wget -q http://get.typo3.org/6.2
          fi

          echo "### unpack tarball ..."
          tar -xzf 6.2

          echo "### delete tarball"
          rm 6.2

          echo "### create symlinks"
          cd /var/www/html
          ln -s ../typo3_src-6.2.* typo3_src
          ln -s typo3_src/index.php index.php
          ln -s typo3_src/typo3 typo3
          # Datei .htaccess bereitstellen wenn nicht vorhanden
          if [ -f .htaccess ]
            then
              echo "### .htaccess file exists"
            else
              echo "### copy typo3 default .htaccess file"
              cp typo3_src/_.htaccess .htaccess
          fi

      fi

    fi

    # TESTING HERE





    # TESTING END

    if [ "$development" = yes ] ; then


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

fi




# TESTING HERE

#cd /var/www/html

# @todo Problems with group rights,  on OSX the shared folder on the host needs 
# to get fixed after every bower package install in bower_components
# admin rights seems to be ok for store in vagrantFolder (see t3source)
# OR: store package file in the Git project maybe in afterBoot.sh or extra script
#echo "### loading jQuery" 
#sudo -H -u dev bower install jquery

#echo "###  Loading Twitter Bootstrap Framework" 
#sudo -H -u dev bower install bootstrap

#echo "###  Loading Twitter Bootstrap Framework" 
#sudo -H -u dev bower install modernizr

# TESTING END


echo "### Installation/Provisioning finished"
finishTime=$(date +%s)
executionTimeSec=$((finishTime - startTime))
executionTime=$(date -u -d @${executionTimeSec} +"%T")
echo "Execution time: $executionTime hh:mm:ss"