# TP Docker : mode d'emploi

Guide rapide pour exécuter tous les scripts, sur Debian 13.

## Arborescence

```
Bureau/docker/
├── install-uninstall_docker/
│   ├── install_docker.sh
│   └── unistall_docker.sh
├── Helloworld/
│   └── Dockerfile
├── nginx-img/
│   └── Dockerfile
├── nginx-ftp/
│   └── docker-compose.yaml
└── registry/
    └── docker-compose.yaml
```

Chaque commande se lance **depuis le dossier concerné** (`cd` d'abord).

---

## 1. Scripts bash : installer / désinstaller Docker

```bash
cd ~/Bureau/docker/install-uninstall_docker
chmod +x *.sh
```

`chmod +x` rend les scripts exécutables.

### Installer Docker

```bash
sudo ./install_docker.sh
```

Vérifier :

```bash
docker --version
docker run --rm hello-world
```

### Désinstaller Docker

> Supprime **tout** : conteneurs, images, volumes, paquets, configuration.

```bash
sudo ./unistall_docker.sh
```

Vérifier :

```bash
docker --version        # doit répondre : commande introuvable
```

### Utiliser Docker sans sudo (optionnel)

```bash
sudo usermod -aG docker $USER
```

Puis se déconnecter et se reconnecter.

---

## 2. Créer un conteneurs Hello World (Dockerfile)

```bash
cd ~/Bureau/docker/Helloworld
docker build -t helloworld .
docker run --name helloworld helloworld
```

Résultat : `Hello World`. Le conteneur s'arrête ensuite, c'est normal.

Recréer :

```bash
docker rm helloworld
docker run --name helloworld helloworld
```

---

## 3. Créer un conteneur Nginx (Dockerfile)

```bash
cd ~/Bureau/docker/nginx-img
docker build -t nginx-job-huit .
docker run -d --name web -p 8080:80 nginx-job-huit
```

Tester :

```bash
curl http://localhost:8080
```

Depuis l'hôte : `http://IP_DE_LA_VM:8080`

Arrêter et supprimer :

```bash
docker rm -f web
```

---

## 4. Nginx + FTP (Docker Compose)

```bash
cd ~/Bureau/docker/nginx-ftp
docker compose config
docker compose up -d
docker compose ps
```

### FileZilla

| Champ | Valeur |
|---|---|
| Hôte | IP de la VM (`IP_DE_LA_VM`) |
| Identifiant | `test` |
| Mot de passe | `test123` |
| Port | `21` |

Envoyer `index.html`, puis ouvrir `http://IP_DE_LA_VM:8080`.

### Arrêter

```bash
docker compose down
```

> **À corriger dans le YAML** : le volume doit être monté sur le même dossier que `FTP_USER_HOME`.
> Remplacer `web:/home/test` par `web:/home/ftptest`, puis `docker compose down` et `docker compose up -d`.

---

## 5. Registry local + interface web (Docker Compose)

```bash
cd ~/Bureau/docker/registry
docker compose config
docker compose up -d
docker compose ps
```

- Registry : `http://localhost:5000/v2/_catalog`
- Interface web : `http://IP_DE_LA_VM:8081`

### Envoyer une image dans le registry

```bash
docker tag nginx-job-huit:latest localhost:5000/nginx-job-huit:1.0
docker push localhost:5000/nginx-job-huit:1.0
```

### Récupérer une image depuis le registry

```bash
docker rmi localhost:5000/nginx-job-huit:1.0
docker pull localhost:5000/nginx-job-huit:1.0
```

### Arrêter

```bash
docker compose down
```

> **À corriger dans le YAML** : la variable s'écrit `REGISTRY_STORAGE_DELETE_ENABLED` (avec un **D** final), sinon la suppression d'images depuis l'interface ne marche pas.

---

## Commandes de contrôle

| Commande | Rôle |
|---|---|
| `docker ps -a` | Liste tous les conteneurs |
| `docker images` | Liste les images |
| `docker logs -f NOM` | Suit les logs d'un conteneur |
| `docker rm -f NOM` | Supprime un conteneur |
| `docker rmi NOM:TAG` | Supprime une image |
| `docker compose down` | Arrête et supprime les services du dossier |

## Rappels importants

- Après modification d'un `docker-compose.yaml` : `docker compose down` puis `docker compose up -d`.
- `docker push` demande d'abord un `docker tag` avec le nom complet `localhost:5000/nom:tag`.
- Depuis la machine hôte, utiliser l'**IP de la VM**, jamais `localhost`.
