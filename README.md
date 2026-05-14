

# Projet

Ce projet a pour but de permettre de lancer une base de donnée PostgreSQL, depuis un serveur
accessible en ssh. Pour disposer d'un tel serveur, l'on passera généralement par un hébergeur
VPS (Virtual Private Server).

Un deuxième but, est de fournir des scripts python ou bash à utiliser en production. Par exemple
le script script/restart.sh permet de redémarrer les containers docker arrétés.

Le serveur PostgreSQL actuellement proposé fonctionne sans cryptage SSL lors des communications
réseaux. Dans le cas d'une politique de sécurité forte, il s'agirait d'un premier point à 
considérer. Pour le reste, au niveau sécurité, le déploiement proposé permet de gérer la gestion 
du mot de passe en serveur, en indiquant celui-ci lors du 1er démarrage de la base de donnée. Le
mot de passe ne pourra ainsi pas être obtenu, même en disposant du code source du programme.



# Déploiement 

Pour démarrer la base de donnée. Connectez-vous à un serveur accessible en ssh. Vous pouvez aussi
réaliser les commandes sur votre ordinateur habituel, afin de tester le lancement de la base de
donnée.

**Étape 1:**

Création de l'image docker "database".   

```sh
docker build -t database  .
```

**Étape 2:**

Créez un répertoire "data" qui sera utilisé par docker. Je vais montrer comment au démarrage
synchroniser la base de donnée avec un répertoire, et non un volume. Et cela car un dossier
est facile à copier, pour réaliser des sauvegardes de la base de donnée.

```sh
mkdir data
```

**Étape 3:**

Démarrage d'un container "cdatabase", utilisant l'image "database", qui stockera en temps réel 
la base de donnée dans le dossier "data" créé à l'étape précédente.

S'il s'agit d'un premier démarrage, vous devrez indiquer le mot de passe de la base de donnée 
avec la commande suivante. Pensez à modifier password par le mot de passe choisit.

```sh
docker run --name cdatabase -e POSTGRES_PASSWORD=password -d -p 5432:5432  --mount type=bind,src=./data,dst=/var/lib/postgresql database
```

S'il s'agit d'une reprise de base de donnée, vous ne devez plus indiquer le mot de passe de la base
de donnée. Et l'on utilise donc la commande suivante.


```sh
docker run --name cdatabase -d -p 5432:5432  --mount type=bind,src=./data,dst=/var/lib/postgresql database 
```

**Utilisateur base de donnée:** tora    
**Mot de passe base de donnée:** -- Mot de passe choisit --    
**Base de donnée:** default   

# Commandes docker

Le déploiement indiqué, permet de démarrer la base de donnée en arrière-plan. Et les logs ne sont 
alors pas visibles. Il n'est pas non plus possible de stopper la base de donnée avec l'habituel 
Ctrl + C.

L'idée est qu'en déploiement il va s'agir du comportement voulu. Et l'on va plutôt gérer la base de
donnée avec les commandes dockers habituelles. Voici les commandes docker de base.

Afficher les logs du container cdatabase

```sh
docker container logs cdatabase
```

Arret du container docker cdatabase

```sh
docker stop cdatabase
```

Reprise du container docker cdatabase

```sh
docker start cdatabase
```

Lister les containers docker

```sh
docker ps --all
```

# Scripts

## restart.sh

Un script qui redemarre tous les containers docker arrétés. Ce script écrit dans un fichier log.txt
le redémarrage, ainsi que la date et l'heure, si un conteneur docker arrété a été trouvé.

L'idée de ce script est bien sur de pouvoir redémarrer des bases de données arrétées. Mais aussi
de relancer des API qui ont subit des attaques informatiques diverses. Car cela est déjà arrivé 2-3 
fois à mes API.

Ce script peut être lancé à intervalle régulier avec un CRON.


# Changement de mot de passe.

Parfois il vous sera nécessaire de changer le mot de passe pour acéder à la base de donnée.
Les cas d'utilisation vont de récupérer une base de donnée localhost mais changer son mot de passe 
par un mot de passe plus sécurisé, à programmer un changement de mot de passe tous les 3 mois.

Changer le mot de passe d'un utilisateur sous PostgreSQL se fait avec la commande suivante.

```sh
ALTER ROLE tora WITH PASSWORD 'hu8jmn3'
```


# FAQ Erreurs fréquentes


## Mot de passe erroné

À chaque fois que vous relancez le container docker vous utiliserez un répertoire appelé "data"
qui contient le contenu de la base de donnée. Ce répertoire stocke aussi un mot de passe de la
base de donnée, ce qui veut dire qu'une fois la première exécution réalisée, il vous sera 
impossible de modifier le mot de passe de la base de donnée.

Il n'est pas possible d'afficher le mot de passe de la base de donnée depuis le serveur.
Veuillez donc conserver le mot de passe de la base de donnée après initialisation.


