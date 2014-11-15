#!/bin/bash
echo "Vagrant-Projekt wird erstellt"

# @todo Testen, ob Vagrant installiert ist, sonst Abbruch mit Fehlermeldung
echo "Vagrant-Verfügbarkeit prüfen"
echo "todo"

# Basissystem auf dem Host bereitstellen 
# @todo Erwirkt einen Fehler, wenn die Box schon bereitgestellt wurde
#       Besser Textmeldung oder unterdrücken
echo "Bereitstellen des Grundsystems"
#vagrant box add ubuntu/trusty64

# In Vagrant-Root-Verzeichnis wechseln
cd vagrant

# Funktions-Auswahl
PS3='Was möchtest du tun? '
options=(
  "Abbrechen"
  "SSH-Zugang - ssh"
  "VM starten - up"
  "VM neu laden - reload"
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