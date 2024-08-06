
# KEYCLOAK CONTAINER DOCKER 👋



## 🙇 Author
#### Cyrille KOZLOWSKI
- Email: [cyrille.kozlowski@ars.sante.fr](mailto:cyrille.kozlowski@ars.sante.fr)

**Version :** 0.1


## 🛠️ Installation
```bash

echo "export IP=$(hostname -I | awk '{print $1}')" >> ~/.bashrc
echo "export KEYCLOAK_PORT=8085" >> ~/.bashrc
source ~/.bashrc
# On clone ce depôt
git clone  ...
cd keycloak
chmod+x ./d

```
        
## 🛠️ Tech Stack
- [Docker](https://www.docker.com//)
- [Docker-compose](https://docs.docker.com/compose/)
    

## 🧑🏻‍💻 Usage

*Pour lancer  keycloak :*

```bash
./d
```

*Parametrer keycloak :*

Changer localhost par l'ip du serveur dans l'onglet client >> annuaire-si-inter-ars (Cf.capture ci-dessous).

Et rajouter l'url de validation de l'application (exemple annuaire si) en fonction du port utilisé 

![Image](https://i.imgur.com/0Z0Z0Z0.png)
        

*Pour backup/restore db keycloak :*

Source : https://osmosys.co/blog/backup-and-restore-of-docker-volumes-a-step-by-step-guide/

```bash
# Ce placer dans le répertoire keycloak
cd keycloak

# Backup
docker run --rm --mount source=docker_postgres_data,target=/post -v $(pwd):/backup busybox tar -czvf /backup/backup.tar.gz /post

# Restorer
docker run --rm --mount source=docker_postgres_data,target=/post -v $(pwd):/backup busybox tar -xzvf /backup/backup.tar.gz -C /
```

