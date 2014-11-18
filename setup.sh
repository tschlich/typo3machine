#!/bin/bash
echo "Vagrant-Projekt wird erstellt"

# @todo Testen, ob Vagrant installiert ist, sonst Abbruch mit Fehlermeldung
#echo "Vagrant-Verfügbarkeit prüfen"

#@todo uncomment
# Basissystem auf dem Host bereitstellen 
#echo "Bereitstellen des Grundsystems"
#vagrant box add ubuntu/trusty64

# In Vagrant-Root-Verzeichnis wechseln
cd vagrant
echo " _   _               _           _   _____     _ _     _   "
echo "| |_| |__   ___  ___| |__       | |_|___ /  __| (_)___| |_ "
echo "| __| '_ \ / _ \/ __| '_ \ _____| __| |_ \ / _\` | / __| __|"
echo "| |_| | | | (_) \__ \ | | |_____| |_ ___) | (_| | \__ \ |_ "
echo " \__|_| |_|\___/|___/_| |_|      \__|____/ \__,_|_|___/\__|"
echo ""
# Funktions-Auswahl
PS3='Was möchtest du tun? (Enter für Menü) '
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
        "VM neu laden - reload")
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