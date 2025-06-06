#!/bin/bash

set -e

### 04_organize_files.sh
# Prepara toda la estructura de carpetas y descomprime los ZIP necesarios para la Plataforma PCD
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

BASE_DIR="/home/ppelaez/PCD-Platform"
ZIP_DIR="/home/ppelaez/scripts/backend"

echo "📁 Preparando estructura base de la plataforma..."

# Crear carpetas backend principales
mkdir -p $BASE_DIR/scripts/gateways
mkdir -p $BASE_DIR/backend/{api-rest,websocket,alerts}
mkdir -p $BASE_DIR/backend/gateways/{goodwe,t301,sonoff,tuya,schneider,sigena,daikin}
mkdir -p $BASE_DIR/backend/services/{document-control,alerts-engine,doc-validator}
mkdir -p $BASE_DIR/backend/ia/{openai-proxy,deepseek-onprem}
mkdir -p $BASE_DIR/backend/support/{passbolt,rustdesk}

# Crear carpetas frontend
mkdir -p $BASE_DIR/frontend/{facit,fyr,portal}

# Crear carpetas K8s por área
mkdir -p $BASE_DIR/kubernetes/core/{postgresql,mongodb,redis,elasticsearch,kibana}
mkdir -p $BASE_DIR/kubernetes/extended/{passbolt,rustdesk,openai-proxy,portal}
mkdir -p $BASE_DIR/kubernetes/gateways/{goodwe,t301,sonoff,tuya,schneider,sigena,daikin}
mkdir -p $BASE_DIR/kubernetes/services/{document-control,alerts-engine,doc-validator}

# BBDD, config y utils
mkdir -p $BASE_DIR/{database/postgres,database/mongo}
mkdir -p $BASE_DIR/config/{nginx,certs,envs}
mkdir -p $BASE_DIR/logs/{api-rest,websocket,alerts}
mkdir -p $BASE_DIR/shared/utils

# Añadir README.md para mantener estructura
find $BASE_DIR -type d -exec touch {}/README.md \;

echo "🗜️ Descomprimiendo fuentes desde $ZIP_DIR..."

function unzip_if_exists() {
  local zipname="$1"
  local dest="$2"
  if [[ -f "$ZIP_DIR/$zipname" ]]; then
    echo "📦 $zipname → $dest"
    unzip -oq "$ZIP_DIR/$zipname" -d "$dest"
  fi
}

# Descomprimir por nombre
unzip_if_exists "api-rest-full-with-docker.zip" "$BASE_DIR/backend/api-rest"
unzip_if_exists "pcd-websocket.zip" "$BASE_DIR/backend/websocket"
unzip_if_exists "alerts.zip" "$BASE_DIR/backend/alerts"
unzip_if_exists "ia.zip" "$BASE_DIR/backend/ia/openai-proxy"
unzip_if_exists "facit-vite.zip" "$BASE_DIR/frontend/facit"
unzip_if_exists "fyr-vite.zip" "$BASE_DIR/frontend/fyr"
unzip_if_exists "document-control.zip" "$BASE_DIR/backend/services/document-control"
unzip_if_exists "alerts-engine.zip" "$BASE_DIR/backend/services/alerts-engine"
unzip_if_exists "doc-validator.zip" "$BASE_DIR/backend/services/doc-validator"
unzip_if_exists "goodwe-gateway.zip" "$BASE_DIR/backend/gateways/goodwe"
unzip_if_exists "t301-gateway.zip" "$BASE_DIR/backend/gateways/t301"
unzip_if_exists "sonoff-gateway.zip" "$BASE_DIR/backend/gateways/sonoff"
unzip_if_exists "tuya-gateway.zip" "$BASE_DIR/backend/gateways/tuya"
unzip_if_exists "schneider-gateway.zip" "$BASE_DIR/backend/gateways/schneider"
unzip_if_exists "sigena-gateway.zip" "$BASE_DIR/backend/gateways/sigena"
unzip_if_exists "daikin-gateway.zip" "$BASE_DIR/backend/gateways/daikin"
unzip_if_exists "gateway-scripts-updated.zip" "$BASE_DIR/scripts/gateways"

echo "✅ Estructura completa generada y ZIPs descomprimidos en: $BASE_DIR"

# 5. Generar requirements.txt si no existen (solo para backends Python)
echo "🧾 Generando requirements.txt si no existen..."
declare -A DEFAULT_REQUIREMENTS=(
  [api-rest]="fastapi\nuvicorn"
  [websocket]="websockets\nuvicorn"
  [alerts]="fastapi\npydantic\nuvicorn"
  [openai-proxy]="requests"
  [document-control]="fastapi\npydantic\npython-multipart"
  [alerts-engine]="fastapi\ngeopy\npydantic"
  [doc-validator]="tesserocr\nfastapi\nuvicorn\npillow"
  [goodwe]="requests\npaho-mqtt"
  [t301]="requests\npaho-mqtt"
  [sonoff]="requests"
  [tuya]="requests"
  [schneider]="requests"
  [sigena]="requests"
  [daikin]="requests"
)

for SERVICE in "${!DEFAULT_REQUIREMENTS[@]}"; do
  DIR="$BASE_DIR/backend"
  if [[ "$SERVICE" == "document-control" || "$SERVICE" == "alerts-engine" || "$SERVICE" == "doc-validator" ]]; then
    DIR="$DIR/services/$SERVICE"
  elif [[ "$SERVICE" == "goodwe" || "$SERVICE" == "t301" || "$SERVICE" == "sonoff" || "$SERVICE" == "tuya" || "$SERVICE" == "schneider" || "$SERVICE" == "sigena" || "$SERVICE" == "daikin" ]]; then
    DIR="$DIR/gateways/$SERVICE"
  elif [[ "$SERVICE" == "openai-proxy" ]]; then
    DIR="$DIR/ia/$SERVICE"
  else
    DIR="$DIR/$SERVICE"
  fi

  REQ="$DIR/requirements.txt"
  ENV="$DIR/.env"

  if [[ -d "$DIR" ]]; then
    if [[ ! -f "$REQ" ]]; then
      echo -e "${DEFAULT_REQUIREMENTS[$SERVICE]}" > "$REQ"
      echo "✔️ Generado: $REQ"
    fi

    if [[ ! -f "$ENV" ]]; then
      echo -e "# .env for $SERVICE\nDEBUG=True\nPORT=8000" > "$ENV"
      echo "✔️ Generado: $ENV"
    fi
  fi
done

echo "✅ Estructura completa generada y ZIPs descomprimidos en: $BASE_DIR"

echo "📦 Generando requirements.txt por tipo de servicio..."

# Servicios FastAPI
FASTAPI_SERVICES=(
  "backend/api-rest"
  "backend/websocket"
  "backend/alerts"
  "backend/services/document-control"
  "backend/services/alerts-engine"
)

for dir in "${FASTAPI_SERVICES[@]}"; do
  FILE="$BASE_DIR/$dir/requirements.txt"
  if [[ -d "$BASE_DIR/$dir" && ! -f "$FILE" ]]; then
    echo -e "fastapi\nuvicorn" > "$FILE"
    echo "📝 Añadido: $FILE"
  fi
done

# Gateways con MQTT
MQTT_SERVICES=(
  "backend/gateways/t301"
  "backend/gateways/goodwe"
  "backend/gateways/sonoff"
  "backend/gateways/tuya"
  "backend/gateways/schneider"
  "backend/gateways/sigena"
  "backend/gateways/daikin"
)

for dir in "${MQTT_SERVICES[@]}"; do
  FILE="$BASE_DIR/$dir/requirements.txt"
  if [[ -d "$BASE_DIR/$dir" && ! -f "$FILE" ]]; then
    echo -e "requests\npaho-mqtt" > "$FILE"
    echo "📝 Añadido: $FILE"
  fi
done

# Servicio de OCR
OCR_SERVICE="backend/services/doc-validator"
FILE="$BASE_DIR/$OCR_SERVICE/requirements.txt"
if [[ -d "$BASE_DIR/$OCR_SERVICE" && ! -f "$FILE" ]]; then
  echo -e "pytesseract\nopencv-python\nnumpy" > "$FILE"
  echo "📝 Añadido: $FILE"
fi

echo "✅ Todos los requirements.txt generados correctamente."

