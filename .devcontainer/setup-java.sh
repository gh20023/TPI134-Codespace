#!/bin/bash
set -e

echo "🟢 Instalando Java 21 y Maven..."
sudo apt-get update
sudo apt-get install -y openjdk-21-jdk maven unzip curl

echo "✅ Java version:"
java -version
mvn -version



