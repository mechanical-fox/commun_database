

# Projet

Ce projet a pour but de permettre de lancer une base de donnée PostgreSQL, depuis un serveur
accessible en ssh. Pour disposer d'un tel serveur, l'on passera généralement par un hébérgeur
VPS (Virtual Private Server).

Le serveur PostgreSQL actuellement proposée fonctionne sans cryptage SSL lors des communications
réseaux. Dans le cas d'une politique de sécurité forte, il s'agirait d'un premier point à
considérer.

Pour le reste, au niveau sécurité, le déploiement proposé permet de gérer la gestion du mot de
passe en serveur, en indiquant celui-ci lors du 1er démarrage de la base de donnée. Le mot de passe
ne pourra ainsi pas être obtenu, même en disposant du code source du programme.



# Deploiement      

Pour démarrer la base de donnée. Connectez vous à un serveur accessible en ssh. Vous pouvez aussi
réaliser les commandes sur votre ordinateur habituel, afin de tester le lancement de la base de donnée.

1. Création de l'image docker "database".   

```sh
docker build -t database  .
```

2. Créez un répertoire "data" qui sera utilisé par docker. Je vais montrer comment au démarrage
synchroniser la base de donnée avec un répertoire, et non un volume. Et cela car un dossier
est facile à copier, pour réaliser des sauvegardes.

```sh
mkdir data
```

3.  Démarrage d'un container "cdatabase" utilisant l'image "database" qui stockera en temps réel la
base de donnée dans le dossier "data" créé à l'étape précédente. Ceci est la commande lors du premier 
démarrage, où vous devrez indiquer le mot de passe à choisir pour la base de donnée. Pensez à modifier
password par le mot de passe choisit.

```sh
docker run --name cdatabase -e POSTGRES_PASSWORD=password -d -p 5432:5432  --mount type=bind,src=./data,dst=/var/lib/postgresql database
```

Et voici donc la commande de démarrage pour les lancements à partir du deuxième lancement. Le mot de 
passe est ici repris depuis le dossier data, qui contient à la fois la base de donnée, et le mot de
passe de la base de donnée.

```sh
docker run --name cdatabase -d -p 5432:5432  --mount type=bind,src=./data,dst=/var/lib/postgresql database 
```

**Utilisateur base de donnée:** tora    
**Mot de passe base de donnée:** -- Mot de passe choisit --    
**Base de donnée:** default   

# Commandes docker

Le déploiement indiqué, permet de démarrer la base de donnée en arrière-plan. Et les logs ne sont alors
pas visibles. Il n'est pas non plus possible de couper la base de donnée avec l'habituel Ctrl + C.

L'idée est qu'en déploiement il va s'agir du comportement voulu. Et l'on peut donc gérer la base de donnée
avec les commandes dockers habituels. Voici les commandes basiques.

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


# FAQ Erreurs fréquentes   


## Mot de passe erroné

A chaque fois que vous relancez le container docker vous utiliserez un répertoire appellé "data"
qui contient le contenu de la base de donnée. Ce répertoire stocke aussi un mot de passe de la
base de donnée, ce qui veut dire qu'une fois la première execution réalisé, il vous sera impossible
de modifier le mot de passe de la base de donnée.

Il n'est pas possible d'afficher le mot de passe de la base de donnée depuis le serveur.
Veuillez donc conserver le mot de passe de la base de donnée après initialisation.



