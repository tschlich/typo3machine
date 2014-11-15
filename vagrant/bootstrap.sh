#!/bin/bash

# Paketquellen aktualisieren
echo "### Paketquellen aktualisieren:"
apt-get update

# Apache installieren
echo "### Apache installieren:"
apt-get install -y apache2

# Webroot auf den gemeinsamen Ordner umleiten
rm -rf /var/www
ln -fs /vagrant /var/www

# Apache2 default webroot-Verzeichnis erstellen
# @todo evtl. vhost erstellen
mkdir -p /var/www/html
cd /var/www/html

# Testseite erstellen, aufrufen und löschen
echo "Apache funktioniert!" > apacheTest.html
wget -qO- 127.0.0.1/apacheTest.html
rm apacheTest.html
