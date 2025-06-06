#!/bin/bash

### 14_sync_admin_template.sh
# Compila, construye y sube la imagen Docker del frontend "facit" al registry privado
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

set -e

FRONTEND_DIR="/home/ppelaez/PCD-Platform/frontend/facit"
REGISTRY="10.0.0.2:5000"
IMAGE_NAME="facit"
TAG="latest"

echo "🔄 Preparando $IMAGE_NAME..."

cd "$FRONTEND_DIR"

echo "🧹 Limpiando node_modules y dist..."
rm -rf node_modules dist package-lock.json

echo "📦 Instalando dependencias..."
npm install --legacy-peer-deps

echo "🔨 Compilando proyecto React..."
npm run build

echo "🐳 Construyendo imagen Docker..."
sudo docker build -t $REGISTRY/$IMAGE_NAME:$TAG .

echo "📤 Subiendo imagen al registry privado..."
sudo docker push $REGISTRY/$IMAGE_NAME:$TAG

echo "✅ Imagen $IMAGE_NAME:$TAG subida al registry con éxito."

exit 0

