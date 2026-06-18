

# Projet

Ce projet a pour but de permettre de lancer une base de donnée PostgreSQL, depuis un serveur
accessible en ssh. Pour disposer d'un tel serveur, l'on passera généralement par un hébergeur
VPS (Virtual Private Server). Ce projet fourni également les bases de données des sites mynrista, 
et erdline, qui sont des projets réalisés sur mon temps libre, que j'utilise en portfolio. Cela 
sont des sites portfolios, donc il n'y a pas d'informations sensibles.

De plus, ce projet fournit également des scripts bash à utiliser en production. Par exemple le script
script/restart.sh permet de redémarrer les containers docker arrétés.

# Backup

Ce projet contient les bases de données de mes sites erdline, et mynrista. Et cela afin qu'un
programmeur souhaitant évaluer mon niveau de développeur, dans le cadre d'un processus de recrutement,
ait quelque chose de concret à executer en localhost, puis à tester.

Les bases de données sont sauvegardées à **backup/erdline_database.zip** et **backup/mynrista_database.zip**.
Si vous souhaitez démarrer ces bases de données, vous allez devoir décompresser le fichier choisit, 
et renommer le fichier décompressé en "data".

Ensuite si vous souhaitez déployer la base de donnée erdline, celle-ci sera à déployer en port 5432.
Port utilisé par l'API Erdline, pour se connecter.

```sh
docker build -t database  .
docker run --name cdatabase -d -p 5432:5432  --mount type=bind,src=./data,dst=/var/lib/postgresql database 
```

Si vous souhaitez plutôt déployer la base de donnée mynrista, celle-ci sera à déployer en port 5433.
Port utilisé par l'API Mynrista, pour se connecter.

```sh
docker build -t database  .
docker run --name cdatabase -d -p 5433:5432  --mount type=bind,src=./data,dst=/var/lib/postgresql database 
```


Pour les deux bases de données sauvegardées, les informations sont les suivantes. Il est à noter que
le mot de passe de ces bases au départ est bien password. On est ici sur des sites de type portfolio,
donc il n'y a pas d'informations sensibles.

**Utilisateur base de donnée:** tora\
**Mot de passe base de donnée:** password\
**Base de donnée:** default


# Déploiement 

Pour démarrer une base de donnée vierge / vide. Connectez-vous à un serveur accessible en ssh. Vous 
pouvez aussi réaliser les commandes sur votre ordinateur habituel, afin de tester le lancement de la 
base de donnée.

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

**Utilisateur base de donnée:** tora \
**Mot de passe base de donnée:** -- Mot de passe choisit -- \
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


# Changement de mot de passe

Parfois il vous sera nécessaire de changer le mot de passe pour accéder à la base de donnée.
Les cas d'utilisation vont de récupérer une base de donnée localhost mais changer son mot de passe 
par un mot de passe plus sécurisé, à programmer un changement de mot de passe tous les 3 mois.

Changer le mot de passe d'un utilisateur sous PostgreSQL se fait avec la commande suivante.
Changer un mot de passe, n'est possible que si vous êtes connecté en base de donnée avec des droits suffisants.

```sh
ALTER ROLE tora WITH PASSWORD 'hu8jmn3'
```


