#!/bin/bash

# Paketquellen aktualisieren
echo "### Paketquellen aktualisieren:"
apt-get update

# Apache installieren
echo "### Apache installieren:"
apt-get install -y apache2

# Testaufruf
echo "Apache funktioniert!" > /var/www/html/index.html
wget -qO- 127.0.0.1
rm /var/www/html/index.html
