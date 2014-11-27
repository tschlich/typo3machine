#!/bin/bash

# @todo Testen, ob Vagrant installiert ist, sonst Abbruch mit Fehlermeldung
#echo "Vagrant-Verfügbarkeit prüfen"

#@todo uncomment
# Basissystem auf dem Host bereitstellen 
#echo "Bereitstellen des Grundsystems"
#vagrant box add ubuntu/trusty64

# In Vagrant-Root-Verzeichnis wechseln
cd vagrant
echo "                                                                ";
echo "   __                                         __    _           ";
echo "  / /___  ______  ____  ____ ___  ____ ______/ /_  (_)___  ___  ";
echo " / __/ / / / __ \/ __ \/ __ \`__ \/ __ \`/ ___/ __ \/ / __ \/ _ \ ";
echo "/ /_/ /_/ / /_/ / /_/ / / / / / / /_/ / /__/ / / / / / / /  __/ ";
echo "\__/\__, / .___/\____/_/ /_/ /_/\__,_/\___/_/ /_/_/_/ /_/\___/  ";
echo "   /____/_/                                                     ";


echo ${headline}

# Funktions-Auswahl
PS3='What to do now? (Enter for menu) '
options=(
  "Abbrechen"
  "SSH-Zugang - ssh"
  "VM starten - up"
  "VM neustarten - reload"
  "VM aktualisieren - provision"
  "VM beenden - halt"
#  "VM pausieren - suspend"
  "VM löschen - destroy"
)
select opt in "${options[@]}"
do
    case $opt in
        "Abbrechen")
            break
            ;;
        "SSH-Zugang - ssh")
            vagrant ssh
            ;;
        "VM starten - up")
            vagrant up
            ;;
        "VM neustarten - reload")
            vagrant reload
            ;;
        "VM aktualisieren - provision")
            vagrant provision
            ;;
        "VM beenden - halt")
            vagrant halt
            ;;
 #       "VM pausieren - suspend")
 #           vagrant suspend
 #           ;;
        "VM löschen - destroy")
            vagrant destroy
            ;;
        *) echo "Ungültige Eingabe";;
    esac
done