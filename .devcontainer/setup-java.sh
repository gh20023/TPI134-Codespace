#!/bin/bash
set -e

echo "🟢 Instalando Java 21 y Maven..."
sudo apt-get update
sudo apt-get install -y openjdk-21-jdk maven unzip curl

echo "✅ Java version:"
java -version
mvn -version

echo "🟢 Descargando Open Liberty 25.0.0.5..."
sudo mkdir -p /opt
cd /opt
sudo curl -L https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release/25.0.0.5/openliberty-25.0.0.5.zip -o openliberty.zip
sudo unzip -q openliberty.zip
sudo rm openliberty.zip
sudo chown -R $(whoami):$(whoami) /opt/wlp

echo "✅ Open Liberty instalado en /opt/wlp"


