#!/bin/bash

echo "=== Configuración de Docker ==="
echo "Docker Version:"
docker --version
echo "Docker Compose Version:"
docker-compose --version

echo "=== Información de usuario ==="
echo "Usuario actual:"
id

echo "=== Permisos del socket Docker ==="
ls -l /var/run/docker.sock

# Obtener el GID real del socket Docker
SOCKET_GID=$(stat -c '%g' /var/run/docker.sock)
echo "GID del socket Docker: $SOCKET_GID"

# Verificar si el usuario jenkins está en el grupo correcto
CURRENT_GROUPS=$(id -G)
echo "Grupos actuales: $CURRENT_GROUPS"

if [[ ! $CURRENT_GROUPS =~ $SOCKET_GID ]]; then
    echo "⚠️  Usuario jenkins no está en el grupo Docker correcto"
    echo "Intentando ajustar grupos..."
    
    # Como root temporal para ajustar grupos
    if [ -w /etc/group ]; then
        # Crear o modificar grupo docker con el GID correcto
        if ! getent group $SOCKET_GID > /dev/null; then
            sudo groupadd -g $SOCKET_GID docker-host || true
        fi
        sudo usermod -aG $SOCKET_GID jenkins || true
    fi
else
    echo "✅ Usuario jenkins tiene acceso al socket Docker"
fi

echo "=== Prueba de Docker ==="
if docker ps > /dev/null 2>&1; then
    echo "✅ Docker funciona correctamente"
else
    echo "❌ Docker no funciona - verificar permisos"
    echo "Intentando con sudo..."
    sudo docker ps || echo "Tampoco funciona con sudo"
fi

echo "=============================="

# Ejecutar Jenkins
exec tini -- /usr/local/bin/jenkins.sh "$@"