#!/bin/bash

### 03_verify_setup.sh
# Verifica que los pasos previos de entorno (01 y 02) se han ejecutado correctamente
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

set -e

LOG="/home/ppelaez/scripts/verify_setup.log"
echo "📋 Verificando entorno..." | tee $LOG

function check_command() {
  CMD=$1
  DESC=$2
  echo -n "🔍 Comprobando $DESC... " | tee -a $LOG
  if command -v $CMD &>/dev/null; then
    echo "✔️ OK" | tee -a $LOG
  else
    echo "❌ NO ENCONTRADO ($CMD)" | tee -a $LOG
    exit 1
  fi
}

function check_service_active() {
  SVC=$1
  echo -n "🔄 Verificando servicio $SVC... " | tee -a $LOG
  if systemctl is-active --quiet $SVC; then
    echo "✔️ Activo" | tee -a $LOG
  else
    echo "❌ Inactivo" | tee -a $LOG
    exit 1
  fi
}

# Verifica binarios necesarios
check_command docker "Docker"
check_command k3s "K3s"
check_command kubectl "kubectl"

# Verifica servicios
check_service_active docker
check_service_active k3s

# Verifica acceso a cluster
echo -n "📡 Acceso a Kubernetes... " | tee -a $LOG
if kubectl get nodes &>/dev/null; then
  echo "✔️ OK" | tee -a $LOG
else
  echo "❌ ERROR de conexión" | tee -a $LOG
  exit 1
fi

# Verifica registry
echo -n "🛰  Comprobando acceso al Docker Registry en 10.0.0.2:5000... " | tee -a $LOG
if curl -s http://10.0.0.2:5000/v2/_catalog | grep -q facit; then
  echo "✔️ Imágenes disponibles" | tee -a $LOG
else
  echo "⚠️ No se listaron imágenes, pero el endpoint responde" | tee -a $LOG
fi

echo "✅ Verificación completa. Todo correcto."
exit 0


### 04_organize_files.sh
# Crea la estructura de carpetas de la plataforma PCD
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

set -e

BASE_DIR="/home/ppelaez/PCD-Platform"
DIRS=(
  "frontend/facit"
  "frontend/fyr"
  "backend/api-rest"
  "backend/websocket"
  "backend/alerts"
  "backend/gateways/goodwe"
  "backend/gateways/t301"
  "backend/ia/openai-proxy"
  "backend/ia/deepseek-onprem"
  "database/postgresql"
  "database/mongodb"
  "database/redis"
  "database/elasticsearch"
  "database/kibana"
  "monitoring"
  "support/passbolt"
  "support/rustdesk"
)

echo "📁 Preparando estructura base de la plataforma..."

for DIR in "${DIRS[@]}"; do
  TARGET="$BASE_DIR/$DIR"
  if [ ! -d "$TARGET" ]; then
    mkdir -p "$TARGET"
    echo "📂 Creada carpeta: $TARGET"
  else
    echo "📂 Ya existe: $TARGET"
  fi
  sleep 0.1

done

echo "✅ Estructura base creada correctamente."

