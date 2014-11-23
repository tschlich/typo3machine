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
development=false

# speed up provisioning for development 
# @todo - remove when different provisioners are implemented
flagInstalled="/home/vagrant/flagInstalled"
if [ -f $flagInstalled ]
  then
    echo "### system allready started"
  else
    echo "### starting project installation"
    # remove linebreak when not developing on vagrant>>    touch $flagInstalled #<<

    if [ "$development" = false ] ; then

      echo "### go to folder /var/www/components"
      cd /var/www/components

      echo "### installing nodejs (apt sources will be updatet)"
      # adding PPA in order to get access to its contents
      curl -sL https://deb.nodesource.com/setup | sudo bash -
      sudo apt-get install -y nodejs

      # The nodejs package contains the nodejs binary as well as npm
      # in order for some npm packages to work (such as those that require 
      # building from source), build-essentials package will be installed
      echo "### installing build-essential"
      sudo apt-get install -y build-essential

      echo "### installing bower global"
      npm install -g bower

      echo "### installing grunt global"
      npm install -g grunt-cli

      echo "### installing nodejs packages"
      npm install

      echo "installing bower packages" 
      sudo -H -u vagrant bower install

      #echo "### installing git"
      #apt-get install -y git

      echo "### installing apache2"
      apt-get install -y apache2

      echo "### removing html dummy"
      rm /var/www/html/index.html

      echo "### enabling vhost"
      a2ensite thosh-t3dist
      # @todo https://

      echo "### adding user t3dist, groups: www-data"
      useradd -G www-data -m -s /bin/bash t3dist

      echo "### setting password to t3dist"
      echo "t3dist:t3dist" | chpasswd

      echo "### adding user dev, groups: vagrant, admin, www-data, t3dist"
      useradd -G vagrant,admin,www-data,t3dist -m -s /bin/bash dev

      echo "### setting password to dev"
      echo "dev:dev" | chpasswd

      echo "### adding groups to existing user vagrant: www-data, dev, t3dist"
      usermod -a -G www-data,dev,t3dist vagrant

      echo "### installing mysql using noninteractive mode"
      export DEBIAN_FRONTEND=noninteractive 
      apt-get install -q -y mysql-server

      echo "### setting password for mysql user root to root"
      mysqladmin -u root password root

      echo "### creating mysql user t3dist with password t3dist"
      mysql -uroot -proot -e "CREATE USER 't3dist'@'localhost' IDENTIFIED BY 't3dist'"

      echo "### creating database t3dist"
      mysql -uroot -proot -e "CREATE DATABASE t3dist CHARACTER SET utf8 COLLATE utf8_general_ci;"

      echo "### setting t3dist privileges"
      # @todo check privileges 
      mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON t3dist . * TO 't3dist'@'localhost'"

      echo "### flushing privileges"
      mysql -uroot -proot -e "FLUSH PRIVILEGES"

      echo "### installing php"
      apt-get install -y php5
      apt-get install -y php5-mysql
      apt-get install -y php5-mcrypt
      #apt-get install -y libapache2-mod-auth-mysql
      #apt-get install -y php5-gd 
      #apt-get install -y php-apc
      #apt-get install -y php-pear

      echo "### restarting apache"
      apache2ctl restart

      echo "### installing additional packages"
      apt-get install -y freetype* 
      apt-get install -y graphicsmagick

      echo "### installing phpMyAdmin"
      # Configure the Settings with debconf-set-selections
      echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
      # Install phpmyadmin with noninteractive mode (it will use the set settings)
      apt-get install -q -y phpmyadmin

      echo "### installing typo3"
      cd /var/www/components
      if [ -d typo3_src-6.2.6 ]
        then
          echo "### sourcecode exists, no action"
          # @todo check md5
        else
          if [ -f 6.2 ]
            then
              echo "### tarball exists, unpacking ..."
            else
              echo "### loading tarball (current 6.2.x) ..."
              wget -q http://get.typo3.org/6.2
          fi # /-f 6.2

          echo "### unpacking tarball ..."
          tar -xzf 6.2

          echo "### deleting tarball"
          rm 6.2

          echo "### creating symlinks"
          cd /var/www/html
          ln -s ../components/typo3_src-6.2.* typo3_src
          ln -s typo3_src/index.php index.php
          ln -s typo3_src/typo3 typo3
          # Datei .htaccess bereitstellen wenn nicht vorhanden
          if [ -f .htaccess ]
            then
              echo "### file .htaccess exists"
            else
              echo "### copying typo3 .htaccess default file"
              cp typo3_src/_.htaccess .htaccess
          fi # /-f .htaccess


      fi # /-d typo3_src-6.2.6

    fi # /"$development" = false

fi # /flagInstalled




# TESTING HERE


# TESTING END


# show execution time
finishTime=$(date +%s)
executionTimeSec=$((finishTime - startTime))
executionTime=$(date -u -d @${executionTimeSec} +"%T")
echo "### Execution time: $executionTime hh:mm:ss"