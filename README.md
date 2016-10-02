# Vagrant project for TYPO3 development

Using this Vagrant configuration you will get a working lamp environment
ready to run through the TYPO3 installation wizard.

## Requirements

Those programs have to be installed and work proper.

- [__Virtualbox__](https://www.virtualbox.org)
- [__Vagrant__](https://www.vagrantup.com)  >= 1.5

__Hint:__ This manual works for _OS X_ and _Linux_. The vagrant project
should also run within Windows, but you can't use the setup.sh then.

## Project files

    + myProject/              // project folder on your host system 
    |
    +- .git/                  // version control system
    |
    +- .gitignore             // files to be ignoriered by version control system
    |
    |- README.md              // project information (this file)
    |
    |- setup.sh               // shell script to run the project
    |
    +-+ vagrant/              // vagrant folder (synced with /vagrant)
    | |
    | +- afterBoot.sh         // runs on every system start
    | |
    | +- provision.sh         // runs on first "vagrant up" and every "vagrant provision"
    | |
    | +- Vagrantfile          // vagrant configuration file
    |
    +-+ vhosts                // sync folder: /etc/apache2/sites-available
      |
      +- typomachine.conf     // vhost configuration file


__Information:__ 

additional files and folders will be added by vm during system is starting.

For a complete uninstall after _vagrant destroy_ remove following files:

 * vagrant/components/bower_components
 * vagrant/components/node_modules
 * vagrant/htdocs
 * vagrant/vhosts/000-default.conf
 * vagrant/vhosts/default-ssl.conf

## Infrastructure

- Linux Ubuntu Server 14.04 LTS (ubuntu/trusty64)
- Apache
- MySQL
- PHP
- PhpMyAdmin ([typomachine.local/phpmyadmin](typomachine.local/phpmyadmin))
- Typo3 6.2.x LTS


## Installation

1. Open project folder in your terminal

        cd /path/to/target
    
1. Start setup script

        sh ./setup.sh
        # if it results in an syntax error, try:
        bash ./setup.sh

1. Select "Start VM"

1. Select "SSH Login"

1. Create file FIRST_INSTALL in web root
 
        touch /var/www/html/FIRST_INSTALL

1. Add this line to your hosts file (/etc/hosts)

        192.168.23.23   typomachine.local
        
    If you want to use another IP you have to configure it in vagrant/Vagrantfile.

1. Open typomachine.local in your web browser to start the installation wizard

1. Step 2: fill in user typomachine with password typomachine

1. Step 3: select database typomachine

1. Step 4: create a user "typomachine" with password "typomachine"

1. Step 5: you can uncheck the box if you want to build your own system, also ignore the following steps then

1. Login in and select "Get Extensions" in the upper box

1. Search for bootstrap_package and install it by clicking on the brick

1. Accept downloading realurl

1. Base install is done, do a git init inside typo3_conf now to control your individual project

1. Start grunt task if you want to get compiled css and javascript
        /var/www/components/grunt watch

1. Create a new page and set this as root page. Find this option in the page configuration filed under behavior/miscellaneous

1. Create a new typoscript Template on this Page

        General
            Template Title: You can name this as you like: Example "Bootstrap Package"
            Website Title: This will be your website title visible in the frontend

        Options
            Clear Constants and Setup by checking the boxes
            Use this Template as Root-Level Template by checking the box

        Includes
            Include static (from extensions)
            CSS Styled Content (required)
            Default TS form (optional if you want to use it)
            Bootstrap Package (required)

1. You can build your site structure now and configure your project by editing the files located on your host system _myProject/htdocs/typo3conf/ext/bootstrap_package_ __Updating bootstrap_package extension is not recommended in this setup!__ Better create your own extension if you want to work serious.

