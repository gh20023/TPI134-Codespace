#!/bin/bash
set -e

echo "Generando docker-compose.yml y levantando Jenkins y Liberty..."

docker-compose up -d --build

echo "Esperando que Jenkins y Liberty arranquen..."
sleep 30

echo "🟢 Jenkins: http://localhost:8080"
echo "🟢 Liberty: http://localhost:9080"


