#!/bin/bash
echo "Vagrant-Projekt wird erstellt"

# @todo Testen, ob Vagrant installiert ist, sonst Abbruch mit Fehlermeldung
echo "Vagrant-Verfügbarkeit prüfen"
echo "keine Informationen verfügbar"

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
  "VM starten - up"
  "VM neu laden - reload"
  "VM beenden - halt"
  "VM pausieren - suspend"
  "SSH-Zugang - ssh"
  "VM löschen - destroy"
  "Abbrechen"
)
select opt in "${options[@]}"
do
    case $opt in
        "VM starten - up")
            vagrant up
            ;;
        "VM neu laden - reload")
            vagrant reload
            ;;
        "VM beenden - halt")
            vagrant halt
            ;;
        "VM pausieren - suspend")
            vagrant suspend
            ;;
        "SSH-Zugang - ssh")
            vagrant ssh
            ;;
        "VM löschen - destroy")
            vagrant destroy
            ;;
        "Abbrechen")
            break
            ;;
        *) echo "Ungültige Eingabe";;
    esac
done