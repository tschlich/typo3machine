#!/bin/bash
echo "Vagrant-Projekt wird erstellt"

# @todo Testen, ob Vagrant installiert ist, sonst Abbruch mit Fehlermeldung

# Basissystem auf dem Host bereitstellen 
# @todo Erwirkt einen Fehler, wenn die Box schon bereitgestellt wurde
#       Besser Textmeldung oder unterdrücken
vagrant box add ubuntu/trusty64

