#!/bin/bash
set -e

# Obtener GID del socket Docker del host
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
echo "Configurando DOCKER_GID: $DOCKER_GID"
export DOCKER_GID

# Detener y limpiar contenedores existentes
echo "Deteniendo contenedores existentes..."
docker-compose down || true

echo "Generando docker-compose.yml y levantando Jenkins y Liberty..."
docker-compose up -d --build

echo "Esperando que Jenkins y Liberty arranquen..."
sleep 30

# Verificar permisos dentro del contenedor Jenkins
echo "Verificando configuración de Docker en Jenkins..."
docker exec jenkins id
docker exec jenkins ls -l /var/run/docker.sock
docker exec jenkins docker --version

echo "🟢 Jenkins: http://localhost:8080"
echo "🟢 Liberty: http://localhost:9080"

