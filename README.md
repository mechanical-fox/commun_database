

# Projet

Ce projet à pour but de permettre de lancer une base de donnée PostgreSQL, depuis un serveur accessible    
en ssh. Pour disposer d'un tel serveur, l'on passera généralement par un hébérgeur VPS (Virtual Private    
Server).     

Le serveur PostgreSQL actuellement proposée fonctionne sans cryptage SSL lors des communications réseaux.    
Dans le cas d'une politique de sécurité forte, il s'agirait d'une premier point à considérer.    

Pour le reste, le déploiement proposé permet de gérer la gestion du mot de passe en serveur, dans une 
variable POSTGRES_PASSWORD, ce qui permet de sécuriser le mot de passe utilisé.    

# FAQ Erreurs fréquentes   

## Mot de passe erroné


A chaque fois que vous relancez le container docker vous utiliserez un répertoire appellé "data" qui contient    
le contenu de la base de donnée. Ce répertoire stocke aussi un mot de passe de la base de donnée, ce qui    
veut dire que une fois la première execution faite, il vous sera impossible de modifier le mot de passe de    
la base de donnée.    

Il n'est pas possible d'afficher le mot de passe de la base de donnée depuis le serveur.   
Veuillez donc conserver le mot de passe de la base de donnée après initialisation.   

# Deploiement      

Pour démarrer la base de donnée.    
Placez vous soit dans un serveur accessible en ssh, soit sur un ordinateur de bureaux.   

1. Création de l'image docker "database".   

```sh
docker build -t database  .
```

2. Créer un répertoire "data" qui sera utilisé par la commande docker.    
Concrétement, l'on va demander à docker de stocker tout le contenu de la base de donnée dans ce répertoire,   
et non dans un volume, afin de pouvoir facilement copier la base de donnée dans le futur.   

```sh
mkdir data
```

3.  Démarrage d'un container "cdatabase" utilisant l'image "database" avec un volume nommé "data".     
Ceci est la commande lors du premier démarrage, ou vous devrez indiquer le mot de passe à choisir pour la base de donnée.   
Pensez à modifier password par le mot de passe choisit.   

```sh
docker run --name cdatabase -e POSTGRES_PASSWORD=password -d -p 5432:5432  --mount type=bind,src=/root/app/database/data,dst=/var/lib/postgresql 
```

Et voici donc la commande de démarrage pour les lancements à partir du deuxième lancement.    
Le mot de passe est ici repris depuis le dossier data, qui contient à la fois la base de donnée, et le mot de passe de la     
base de donnée.   

```sh
docker run --name cdatabase -d -p 5432:5432  --mount type=bind,src=/root/app/database/data,dst=/var/lib/postgresql 
```

Utilisateur base de donnée: tora    
Mot de passe base de donnée: -- Mot de passe choisit --    
Base de donnée: default    

