#!/bin/bash

# 1. supprimee les conteneurs, images, volumes etc
if command -v docker >/dev/null 2>&1; then
    docker rm -f $(docker ps -aq) 2>/dev/null
    docker system prune -a --volumes -f
fi

# 2. arrete les services docker
systemctl stop docker.service docker.socket containerd.service
systemctl disable docker.service docker.socket containerd.service

# 3. supprime les paquets docker et fichier de config
apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# 4. supprime les dependances devenu inutile
apt-get autoremove -y --purge

# 5. supprime les donnees restante (images, volumes, config)
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
rm -rf /etc/docker

# 6. supprime le depot docker et la key gpg
rm -f /etc/apt/sources.list.d/docker.list
rm -f /etc/apt/keyrings/docker.asc

# 7. maj (plus de depot docker)
apt-get update

# 8. verifie que tout est supprimer
dpkg -l | grep -Ei "docker|containerd" || echo "OK : docker est eradiquer. lol"
