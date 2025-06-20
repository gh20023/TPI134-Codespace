#!/bin/bash
set -e

echo "=== Configuración de Docker ==="
docker --version
docker-compose --version

echo "=== Información de usuario ==="
id

echo "=== Permisos del socket Docker ==="
ls -l /var/run/docker.sock

# Obtener GID del socket Docker
SOCKET_GID=$(stat -c '%g' /var/run/docker.sock)
echo "GID del socket Docker: $SOCKET_GID"

# Crear grupo si no existe
if ! getent group $SOCKET_GID > /dev/null; then
    echo "Creando grupo docker-host con GID $SOCKET_GID..."
    sudo groupadd -g $SOCKET_GID docker-host || echo "El grupo ya existe o no se pudo crear"
fi

# Agregar usuario jenkins al grupo
echo "Agregando usuario jenkins al grupo $SOCKET_GID..."
sudo usermod -aG $SOCKET_GID jenkins || echo "No se pudo agregar al grupo"

# Verificar membresía actualizada
echo "Grupos actuales: $(id -Gn)"

echo "=== Prueba de Docker ==="
if docker ps > /dev/null 2>&1; then
    echo "✅ Docker funciona correctamente"
else
    echo "❌ Docker no funciona - verificar permisos"
    echo "Intentando con grupos actualizados..."
    
    # Ejecutar prueba con nuevo contexto de grupos
    if sudo -E -u jenkins docker ps > /dev/null 2>&1; then
        echo "✅ Docker funciona con nuevo contexto de grupos"
    else
        echo "❌ Fallo persistente - mostrando información de diagnóstico:"
        ls -l /var/run/docker.sock
        groups jenkins
        getent group $SOCKET_GID
        sudo -E -u jenkins docker ps || true
    fi
fi

echo "=============================="

# Ejecutar Jenkins normalmente
echo "Iniciando Jenkins..."
exec tini -- /usr/local/bin/jenkins.sh "$@"