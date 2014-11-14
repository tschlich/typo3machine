#!/bin/bash
echo "Vagrant-Projekt wird erstellt"

# @todo Testen, ob Vagrant installiert ist, sonst Abbruch mit Fehlermeldung
echo "Vagrant-Verfügbarkeit prüfen"
echo "keine Informationen verfügbar"

# Basissystem auf dem Host bereitstellen 
# @todo Erwirkt einen Fehler, wenn die Box schon bereitgestellt wurde
#       Besser Textmeldung oder unterdrücken
echo "Bereitstellen des Grundsystems"
vagrant box add ubuntu/trusty64

# @todo Auswahlliste der Funktionen 
# Mögliche Funktionen sind z.B. 
# Start, Reload, Provision, Shutdown, Suspend, Destroy, Command Line
echo "Ausgabe der Funktions-Auswahl (todo)"