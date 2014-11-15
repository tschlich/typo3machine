#!/bin/bash

# Paketquellen aktualisieren
apt-get update

# Apache installieren
apt-get install -y apache2

# Webroot auf den gemeinsamen Ordner umleiten
rm -rf /var/www
ln -fs /vagrant /var/www
