#!/bin/bash

### 17_reset_and_prepare_fyr.sh
# Resetea completamente el frontend FYR, reinstala dependencias y genera la imagen Docker
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

set -e

BASE_DIR="/home/ppelaez/PCD-Platform/frontend"
FOLDER="fyr"
ZIP_SOURCE="/home/ppelaez/scripts/fyr-vite.zip"
TARGET="$BASE_DIR/$FOLDER"
REGISTRY="10.0.0.2:5000"

echo "🧹 Eliminando versión anterior de $FOLDER..."
rm -rf "$TARGET"
mkdir -p "$TARGET"

echo "📦 Descomprimiendo ZIP directamente en $FOLDER..."
unzip -oq "$ZIP_SOURCE" -d "$TARGET"

echo "📁 Carpeta destino: $TARGET"
cd "$TARGET"

echo "📦 Instalando dependencias (modo legacy)..."
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps --no-cache

echo "🔨 Compilando build de producción..."
npm run build

echo "📝 Generando Dockerfile..."
cat <<EOF > "$TARGET/Dockerfile"
FROM nginx:alpine
COPY dist /usr/share/nginx/html
EOF

echo "🐳 Construyendo imagen Docker para $FOLDER..."
sudo docker build -t $REGISTRY/$FOLDER:latest .

echo "📤 Subiendo imagen al registry privado..."
sudo docker push $REGISTRY/$FOLDER:latest

echo "✅ FYR desplegado correctamente."

