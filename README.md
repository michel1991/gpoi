### TP: CREATION D'UNE PLATEFORME DE GESTION DE POI MASTER 2 MBDS 2016-2017
# 
## PRESENTATION
L'objectif de ce TP est la prise en main du Framework Grails permettant de concevoir une application web rapidement. Permettant ainsi au développeur de se concentrer sur la logique métier
## OUTILS DE DEVELOPPEMENT

- Java 7

- Grails 2.5.4

- IntelliJ IDEA Ultimate dont la dernière version

- MySQL

- Un serveur Apache
## INSTALLATION DE L'APPLICATION
Le projet est fourni avec deux dossiers celui contenant l'application du TP et celui contenant l'application web pour la gestion des images utilisant un serveur apache. La procédure d'installation est la suivante:

- Placez le répertoire **gpoi** à la racine de votre serveur Apache (exemple: racine du répertoire www Apache). Ce répertoire gpoi contient des images de l'application 

- Créez une base de donnée sur Mysql. Editez votre fichier «  DataSource.groovy  »  pour le faire pointer sur votre nouvelle base de données. Voir la section environments ->development->dataSource, de ce fichier. Renseignez le username, password, url.

- Editez le fichier **Config.groovy**, modifiez la valeur de propriété **grails.projet.gpoi.server.folder.image** avec le path du répertoire gpoi. Exemple:"C:/wamp/www/gpoi/images/". Ne pas oublier le dernier slash. Faites de même avec la propriété **grails.projet.gpoi.server.localisation.images** permettant de joindre les images de l'application par le biais de votre serveur apache. Exemple: "http://localhost/gpoi/images/". Ne pas oublier également le dernier slash.

- Note: Avant de lancer l'application, lancez, votre serveur Apache et votre serveur de base de données

