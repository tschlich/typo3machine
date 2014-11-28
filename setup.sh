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
  "Cancel"
  "SSH Login   - vagrant ssh"
  "Start VM    - vagrant up"
  "Restart VM  - vagrant reload"
  "Shutdown VM - vagrant halt"
  "Rebuild VM  - vagrant provision (discard local changes)"
  "Destroy VM  - vagrant destroy"
)

select opt in "${options[@]}"
do
  case $opt in
    ${options[0]})
      # Cancel
      break
      ;;
    ${options[1]})
      # ssh
      vagrant ssh
      ;;
    ${options[2]})
      # up
      vagrant up
      ;;
    ${options[3]})
      # reload
      vagrant reload
      ;;
    ${options[4]})
      # halt
      vagrant halt
      ;;
    ${options[5]})
      # provision
      vagrant provision
      ;;
    ${options[6]})
      # destroy
      vagrant destroy
      ;;
    *) echo "Action unknown";;
    esac
done