#!/bin/bash

# execution time start
startTime=$(date +%s)

# debug marker
marker="#######################################################################"$'\r\n'
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
#development=true
development=false

# speed up provisioning for development 
# @todo - remove when different provisioners are implemented
flagInstalled="/home/vagrant/flagInstalled"
if [ -f $flagInstalled ]
  then
    echo "${marker}### system allready started"
  #else
    echo "${marker}### starting project installation"
    # remove linebreak when not developing on vagrant>>
    touch $flagInstalled #<<

    if [ "$development" = false ] ; then

      echo "${marker}### go to folder /var/www/components"
      cd /var/www/components

      echo "${marker}### installing nodejs (apt sources will be updated)"
      # adding PPA in order to get access to its contents
      curl -sL https://deb.nodesource.com/setup | sudo bash -
      sudo apt-get install -y nodejs

      # The nodejs package contains the nodejs binary as well as npm
      # in order for some npm packages to work (such as those that require 
      # building from source), build-essentials package will be installed
      echo "${marker}### installing build-essential"
      sudo apt-get install -y build-essential

      echo "${marker}### installing bower global"
      npm install -g bower

      echo "${marker}### installing grunt global"
      npm install -g grunt-cli

      echo "${marker}### installing nodejs packages"
      npm install

      echo "installing bower packages" 
      sudo -H -u vagrant bower install

      #echo "${marker}### installing git"
      #apt-get install -y git

      echo "${marker}### installing apache2"
      apt-get install -y apache2

      echo "${marker}### removing html dummy"
      rm /var/www/html/index.html

      echo "${marker}### enabling vhost"
      a2ensite typomachine
      # @todo https://

      echo "${marker}### adding user typomachine, groups: www-data"
      useradd -G www-data -m -s /bin/bash typomachine

      echo "${marker}### setting password to typomachine"
      echo "typomachine:typomachine" | chpasswd

      echo "${marker}### adding user dev, groups: vagrant, admin, www-data, typomachine"
      useradd -G vagrant,admin,www-data,typomachine -m -s /bin/bash dev

      echo "${marker}### setting password to dev"
      echo "dev:dev" | chpasswd

      echo "${marker}### adding groups to existing user vagrant: www-data, dev, typomachine"
      usermod -a -G www-data,dev,typomachine vagrant

      echo "${marker}### installing mysql using noninteractive mode"
      export DEBIAN_FRONTEND=noninteractive 
      apt-get install -q -y mysql-server

      echo "${marker}### setting password for mysql user root to root"
      mysqladmin -u root password root

      echo "${marker}### creating mysql user typomachine with password typomachine"
      mysql -uroot -proot -e "CREATE USER 'typomachine'@'localhost' IDENTIFIED BY 'typomachine'"

      echo "${marker}### creating database typomachine"
      mysql -uroot -proot -e "CREATE DATABASE typomachine CHARACTER SET utf8 COLLATE utf8_general_ci;"

      echo "${marker}### setting typomachine privileges"
      # @todo check privileges 
      mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON typomachine . * TO 'typomachine'@'localhost'"

      echo "${marker}### flushing privileges"
      mysql -uroot -proot -e "FLUSH PRIVILEGES"

      echo "${marker}### installing php"
      apt-get install -y php5
      apt-get install -y php5-mysql
      # @todo phpmyadmin reports error
      apt-get install -y php5-mcrypt
      #apt-get install -y libapache2-mod-auth-mysql
      #apt-get install -y php5-gd 
      #apt-get install -y php-apc
      #apt-get install -y php-pear

      echo "modifying php.ini"
      upload_max_filesize=10M
      post_max_size=10M
      max_execution_time=240
      for key in upload_max_filesize post_max_size max_execution_time
      do
       sudo sed -i "s/^\($key\).*/\1 $(eval echo = \${$key})/" /etc/php5/apache2/php.ini
      done

      echo "${marker}### restarting apache"
      apache2ctl restart

      echo "${marker}### installing additional packages"
      apt-get install -y freetype* 
      apt-get install -y graphicsmagick

      echo "${marker}### installing phpMyAdmin"
      # Configure the Settings with debconf-set-selections
      echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
      echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
      # Install phpmyadmin with noninteractive mode (it will use the set settings)
      apt-get install -q -y phpmyadmin

      echo "${marker}### installing typo3"
      cd /var/www/components
      if [ -d typo3_src-6.2.6 ]
        then
          echo "${marker}### sourcecode exists, no action"
          # @todo check md5
        else
          if [ -f 6.2 ]
            then
              echo "${marker}### tarball exists, unpacking ..."
            else
              echo "${marker}### loading tarball (current 6.2.x) ..."
              wget -q http://get.typo3.org/6.2
          fi # /-f 6.2

          echo "${marker}### unpacking tarball ..."
          tar -xzf 6.2

          echo "${marker}### deleting tarball"
          rm 6.2

      fi # /-d typo3_src-6.2.6

      echo "${marker}### creating symlinks"
      cd /var/www/html
      ln -s ../components/typo3_src-6.2.* typo3_src
      ln -s typo3_src/index.php index.php
      ln -s typo3_src/typo3 typo3
      
      # Datei .htaccess bereitstellen wenn nicht vorhanden
      # @todo - remove, if later still don't wanted. 
      # Meanwhile the bootstrap_package version of .htaccess is used
      #if [ -f .htaccess ]
      #  then
      #    echo "${marker}### file .htaccess exists"
      #  else
      #    echo "${marker}### copying typo3 .htaccess default file"
      #    cp typo3_src/_.htaccess .htaccess
      #fi # /-f .htaccess

      echo "##############################################################"
      echo "##################### F I N I S H E D ! ######################" 
      echo "##############################################################"
      echo "########## Maybe you want to start less compilation? #########"
      echo "##################### ssh connect and run ####################" 
      echo "############ /vagrant/www/components/grunt watch #############" 
      echo "##############################################################"
      echo "######################## Have fun! ###########################"
      echo "##############################################################"

    fi # /"$development" = false

fi # /flagInstalled




# TESTING HERE
# TESTING END


# show execution time
finishTime=$(date +%s)
executionTimeSec=$((finishTime - startTime))
executionTime=$(date -u -d @${executionTimeSec} +"%T")
echo "${marker}### Execution time: $executionTime hh:mm:ss"