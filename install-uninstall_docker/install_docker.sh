#!/bin/bash

set -e   # arrete le script si une commande ne fonctionne pas

# 1. maj et installer curl + certificats pour le HTTPS
apt-get update
apt-get install -y ca-certificates curl

# 2. creer le dossier des keyss et telecharger la key gpg officielle de docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# 3. ajouter le depot docker a APT signer avec key
. /etc/os-release
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $VERSION_CODENAME stable" > /etc/apt/sources.list.d/docker.list

# 4. maj + installer docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Demarrer docker et l'activer au demarrage
systemctl enable --now docker

# 6. Test
docker --version
docker run --rm hello-world
