# Web-Entwicklung mit Vagrant
@todo Dieses Vagrant-Projekt erstellt eine VM mit vorinstalliertem TYPO3 inkl. 
der Erweiterung bootstrap_package. 

## Voraussetzungen
Diese Programme müssen installiert sein und funktionieren:

- [__Virtualbox__](https://www.virtualbox.org)
- [__Vagrant__](https://www.vagrantup.com)

__Hinweis:__ Diese Projektbeschreibung ist gültig für _OSX_ und _Linux_. 
Das Vagrant-Projekt selbst sollte aber auch unter _Windows_ eingesetzt werden können.
Es muss dann allerdings auf die setup.sh verzichtet werden.

## Projektdateien

    + WebEntwicklung/         // Projekt-Verzeichnis 
    |
    +- .git/                  // Git-Versionskontrolle
    |
    +- .gitignore             // von Git zu ignorierende Dateien
    |
    |- README.md              // Projekt-Informationen (diese Datei)
    |
    |- setup.sh               // Shell-Skript zum Einrichten des Projekts
    |
    +-+ vagrant/              // Vagrant-Verzeichnis
      |
      |- afterBootstrap.sh    // Aktionen nach jedem Systemboot
      |
      |- bootstrap.sh         // Aktionen nach dem 1. Systemboot oder "vagrant provision"
      |
      |-+ components          // sync folder: /var/www/components (so you can browse data on host os)
      | |
      | +- bower.json         // bower setup file
      | |
      | +- package.json       // nodejs setup file
      |
      |- Vagrantfile          // Der Bauplan der VM
      |
      +-+ vhosts              // Gemeinsamer Ordner: /etc/apache2/sites-available
        |
        +- typomachine.conf   // vhost-Konfiguration


__Information:__ 

additional files and folders will be added by vm during system is starting.

For a complete uninstall after _vagrant destroy_ remove following files:

 * vagrant/components/bower_components
 * vagrant/components/node_modules
 * vagrant/htdocs
 * vagrant/vhosts/000-default.conf
 * vagrant/vhosts/default-ssl.conf

Dieser "Bauplan" ist unter Versionskontrolle (git).

## Infrastruktur
- Linux Ubuntu Server 14.04 LTS (ubuntu/trusty64)
- Apache
- MySQL
- PHP
- PhpMyAdmin ([typomachine.local/phpmyadmin](typomachine.local/phpmyadmin))
- Typo3 6.2.x LTS


## Installation

Wer Vagrant kennt, kann auf das Setup-Skript verzichten. 
Das Skript stellt sicher, daß auf dem Host die box _ubuntu/trusty64_ 
verfügbar ist, wechselt in das Verzeichnis _vagrant_ und stellt 
ein Menü der Vagrant-Befehle zur Verfügung.

Installation unter Verwendung des Setup-Skripts:

1. Dieses Verzeichnis im Terminal öffnen

        cd /pfad/zum/ziel
    
1. Das Setup-Skript starten 

        ./setup.sh

1. "VM starten - up" auswählen und warten

1. "SSH-Zugang - ssh" auswählen

1. Typo3 erfordert für die Installation die Datei FIRST_INSTALL im webroot
        touch /var/www/html/FIRST_INSTALL

1. Sofern HTML-Templates oder LESS-Dateien geändert werden sollen, muss grunt
   gestartet werden
        /var/www/components/grunt watch

1. die URL typomachine.local im Browser aufrufen

1. Step 2: fill in user typomachine with password typomachine

1. Step 3: select database typomachine

1. Step 4: create your user with your password

1. Step 5: you can uncheck the box if you want to build your own system

1. after login in select "Get Extensions" in the select box at the top 

1. search for bootstrap_package and install this extension

1. accept downloading realurl

1. install german translations

1. you better do a git init inside typo3_conf and commit now

1. 

1. 

1. 

1. 

1. 

1. 

1. 

1. 

1. 

1. 

1. 

1. 




### Todo

- Distribution-Extension "typomachine" (evtl. auf bootstrap_package basierend)
- Git-Versionierung der Typo3-Distribution "typomachine"
- Git-Versionierung des zu erstellenden Web-Projekts (quasi das Produkt des Vagrant-Projekts)
- Einsatz von Bower als Paketmanager?
- Einsatz von Grunt als Taskmanager?
- LESS / SASS
- jQuery
- bootstrap
- nodeJS
- Checken: chef, puppet, Capistrano, ...