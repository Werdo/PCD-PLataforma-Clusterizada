#!/bin/bash

### deploy_gateway_goodwe.sh
# Construye y sube el gateway GoodWe al registry privado
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e

SERVICE_NAME="goodwe"
BASE_DIR="/home/ppelaez/PCD-Platform/backend/gateways/$SERVICE_NAME"
REGISTRY="10.0.0.2:5000"

echo "🔄 Preparando gateway $SERVICE_NAME..."

# Crear directorio
if [ ! -d "$BASE_DIR" ]; then
  echo "📁 Creando directorio base: $BASE_DIR"
  mkdir -p "$BASE_DIR"
fi

# Dockerfile
DOCKERFILE="$BASE_DIR/Dockerfile"
if [ ! -f "$DOCKERFILE" ]; then
  echo "📝 Generando Dockerfile..."
  cat <<EOF > "$DOCKERFILE"
FROM python:3.11-slim

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir --upgrade pip && \\
    pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]
EOF
fi

# requirements.txt
REQ="$BASE_DIR/requirements.txt"
if [ ! -f "$REQ" ]; then
  echo "📦 Generando requirements.txt..."
  echo "requests\npaho-mqtt" > "$REQ"
fi

# main.py
MAIN="$BASE_DIR/main.py"
if [ ! -f "$MAIN" ]; then
  echo "⚙️ Generando main.py de ejemplo..."
  cat <<EOF > "$MAIN"
import time

def main():
    while True:
        print("[GOODWE] Enviando datos simulados...")
        time.sleep(10)

if __name__ == "__main__":
    main()
EOF
fi

# .env
ENV_FILE="$BASE_DIR/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "🔐 Generando archivo .env..."
  echo "# Configuración para gateway GoodWe" > "$ENV_FILE"
fi

# Build y push
echo "🐳 Construyendo imagen Docker..."
sudo docker build -t $REGISTRY/gateway-$SERVICE_NAME:latest "$BASE_DIR"

echo "📤 Subiendo imagen al registry..."
sudo docker push $REGISTRY/gateway-$SERVICE_NAME:latest

echo "✅ Gateway $SERVICE_NAME desplegado correctamente."

