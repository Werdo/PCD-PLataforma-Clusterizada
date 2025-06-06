#!/bin/bash

### deploy_api-rest.sh
# Construye y sube el microservicio API REST al registry privado
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e

SERVICE_NAME="api-rest"
BASE_DIR="/home/ppelaez/PCD-Platform/backend/$SERVICE_NAME"
REGISTRY="10.0.0.2:5000"

echo "🔄 Preparando microservicio $SERVICE_NAME..."

# Crear carpeta si no existe
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

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF
fi

# requirements.txt
REQ="$BASE_DIR/requirements.txt"
if [ ! -f "$REQ" ]; then
  echo "📦 Generando requirements.txt..."
  echo "fastapi\nuvicorn[standard]\npsycopg2" > "$REQ"
fi

# main.py
MAIN="$BASE_DIR/main.py"
if [ ! -f "$MAIN" ]; then
  echo "⚙️ Generando main.py..."
  cat <<EOF > "$MAIN"
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "API REST lista"}
EOF
fi

# .env
ENV_FILE="$BASE_DIR/.env"
if [ ! -f "$ENV_FILE" ]; then
  echo "🔐 Generando archivo .env..."
  echo "# Configuración para API REST" > "$ENV_FILE"
fi

# Build y push
echo "🐳 Construyendo imagen Docker..."
sudo docker build -t $REGISTRY/$SERVICE_NAME:latest "$BASE_DIR"

echo "📤 Subiendo imagen al registry..."
sudo docker push $REGISTRY/$SERVICE_NAME:latest

echo "✅ Microservicio $SERVICE_NAME desplegado correctamente."

