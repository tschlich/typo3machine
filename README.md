# Web-Entwicklung mit Vagrant
Dieses Vagrant-Projekt dient der Erarbeitung eines
Workflows zum Entwickeln von Webseiten.
 
## Projektdateien

    WebEntwicklung            // Projekt-Verzeichnis 
    |_ README.md              // Projekt-Informationen (diese Datei)
    |_ setup.sh               // Shell-Skript zum Einrichten des Projekts
    |_ vagrant/               // Vagrant-Verzeichnis
      |_ Vagrantfile          // Der Bauplan der virtuellen Maschine (VM)
      |_                      // 
      |_                      // 
      |_                      // 
      |_                      // 
      |_                      // 

Dieser "Bauplan" ist unter Versionskontrolle (git).

In der VM wird ein Typo3 mit der Distribution-Extension "Thosh" installiert.
Diese Distribution soll auf der Extension bootstrap_package aufbauen (die auch 
von der offiziellen Distribution "Introduction" eingesetzt wird). 
Eventuell werde ich aber auch ein eigenständiges Template aufbauen wie z.B. im [PanadeEdu-Tutorial](https://github.com/PanadeEdu/tutorial_vm "Tutorial auf Github")


## Infrastruktur
- Linux Ubuntu Server 14.04 LTS (ubuntu/trusty64)

## 

### Todo
- Shell-Script zum Erstellen des Projekts ([PanadeEdu (.bat für Windows)](https://github.com/PanadeEdu/tutorial_vm/blob/master/startscript.bat), [Provisioning Vagrant with a shell script](http://laravel-recipes.com/recipes/23/provisioning-vagrant-with-a-shell-script))
- Apache Version?
- MySQL Version? (evtl. MariaDB)
- PHP Version?
- PhpMyAdmin
- TYPO3 6.2.6 LTS
- Distribution-Extension "Thosh" (evtl. auf bootstrap_package basierend)
- Git-Versionierung des Vagrant-Projekts
- Git-Versionierung der Typo3-Distribution "Thosh"
- Einrichtung des Projekts für die Zusammenarbeit mehrerer Entwickler (System, htdocs, migrations)
- Einsatz von Bower als Paketmanager
- Einsatz von Grunt als Taskmanager