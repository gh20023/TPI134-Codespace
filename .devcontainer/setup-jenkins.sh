#!/bin/bash

echo "==================================="
echo "Instalando docker-compose..."
echo "==================================="

apt-get update
apt-get install -y curl

curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "docker-compose version:"
docker-compose version

echo "==================================="
echo "Instalando y levantando Jenkins..."
echo "==================================="

mkdir -p jenkins

cat > docker-compose.yml <<EOF
version: '3.8'

services:
  jenkins:
    build:
      context: .
      dockerfile: Dockerfile.jenkins
    container_name: jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    restart: unless-stopped

volumes:
  jenkins_home:
EOF


docker-compose up -d

echo "Esperando a que Jenkins arranque..."
sleep 30

echo "==================================="
echo " Jenkins levantado en http://localhost:8080"
echo " Para ver la contraseña inicial:"
echo " docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
echo "==================================="

