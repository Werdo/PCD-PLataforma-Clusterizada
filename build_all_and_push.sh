#!/bin/bash

### build_all_and_push.sh
# Compila y sube todas las APIs y Gateways desplegadas en la PCD
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e

BASE_DIR="/home/ppelaez/PCD-Platform"
REGISTRY="10.0.0.2:5000"

# Lista de servicios (relativos al BASE_DIR)
SERVICES=(
  "backend/api-rest"
  "backend/websocket"
  "backend/alerts"
  "backend/ia/openai-proxy"
  "backend/support/passbolt"
  "backend/support/rustdesk"
  "backend/services/document-control"
  "backend/services/alerts-engine"
  "backend/services/doc-validator"
  "backend/gateways/goodwe"
  "backend/gateways/t301"
  "backend/gateways/sonoff"
  "backend/gateways/tuya"
  "backend/gateways/schneider"
  "backend/gateways/sigena"
  "backend/gateways/daikin"
)

for service in "${SERVICES[@]}"; do
  NAME=$(basename "$service")
  FULL_PATH="$BASE_DIR/$service"

  echo "\n🔄 Procesando servicio: $NAME"

  if [ ! -d "$FULL_PATH" ]; then
    echo "⚠️  Directorio no encontrado: $FULL_PATH"
    continue
  fi

  cd "$FULL_PATH"

  if [ ! -f Dockerfile ]; then
    echo "❌ Falta Dockerfile en $FULL_PATH. Saltando."
    continue
  fi

  echo "🐳 Construyendo imagen Docker para $NAME..."
  sudo docker build -t $REGISTRY/$NAME:latest . || { echo "❌ Error al compilar $NAME"; continue; }

  echo "📤 Subiendo imagen al registry $REGISTRY/$NAME:latest..."
  sudo docker push $REGISTRY/$NAME:latest || { echo "❌ Error al subir $NAME"; continue; }

  echo "✅ $NAME compilado y subido correctamente."

done

cd ~/scripts

echo "\n🏁 Proceso completo. Todas las imágenes procesadas."

