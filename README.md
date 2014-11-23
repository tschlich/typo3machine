# Web-Entwicklung mit Vagrant
Dieses Vagrant-Projekt dient der Erarbeitung eines 
Workflows zum Entwickeln von Webseiten mit Typo3.

## Idee
In der VM wird ein Typo3 mit der Distribution-Extension "Thosh" installiert.
Diese Distribution soll auf der Extension bootstrap_package aufbauen (die auch 
von der offiziellen Distribution "Introduction" eingesetzt wird). 
Eventuell werde ich aber auch ein eigenständiges Template aufbauen wie z.B. im 
[PanadeEdu-Tutorial](https://github.com/PanadeEdu/tutorial_vm "Tutorial auf Github")

## Voraussetzungen
Diese Programme müssen installiert sein und funktionieren:

- [__Virtualbox__](https://www.virtualbox.org)
- [__Vagrant__](https://www.vagrantup.com)

__Hinweis:__ Diese Projektbeschreibung ist gültig für _OSX_ und _Linux_. Das Vagrant-Projekt selbst sollte aber auch unter _Windows_ eingesetzt werden können.

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
        +- thosh-t3dist.conf  // vhost-Konfiguration


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
- PhpMyAdmin ([thosh-t3dist.local/phpmyadmin](thosh-t3dist.local/phpmyadmin))
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
        touch /vagrant/html/FIRST_INSTALL

1. Sofern HTML-Templates oder LESS-Dateien geändert werden sollen, muss grunt
   gestartet werden
        /vagrant/components/grunt watch


### Todo

- Distribution-Extension "thosh-t3dist" (evtl. auf bootstrap_package basierend)
- Git-Versionierung der Typo3-Distribution "thosh-t3dist"
- Git-Versionierung des zu erstellenden Web-Projekts (quasi das Produkt des Vagrant-Projekts)
- Einsatz von Bower als Paketmanager?
- Einsatz von Grunt als Taskmanager?
- LESS / SASS
- jQuery
- bootstrap
- nodeJS
- Checken: chef, puppet, Capistrano, ...