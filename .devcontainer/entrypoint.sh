#!/bin/bash

# Solo verificaciones (sin cambiar permisos)
echo "=== Docker Version ==="
docker --version
echo "=== Docker Compose Version ==="
docker-compose --version
echo "=== Grupos de usuario ==="
id
echo "=== Permisos del socket ==="
ls -l /var/run/docker.sock
echo "=============================="

# Ejecutar Jenkins
exec tini -- /usr/local/bin/jenkins.sh "$@"