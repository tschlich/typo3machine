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

# Funktions-Auswahl
PS3='Was möchtest du tun? '
options=(
  "VM starten"
  "VM neu laden"
  "VM stoppen"
  "Abbrechen"
)
select opt in "${options[@]}"
do
    case $opt in
        "VM starten")
            echo "@todo VM starten"
            ;;
        "VM neu laden")
            echo "@todo VM neu laden"
            ;;
        "VM stoppen")
            echo "@todo VM stoppen"
            ;;
        "Abbrechen")
            break
            ;;
        *) echo "Ungültige Eingabe";;
    esac
done