#!/bin/bash

set -e

### 00_validate_platform_structure.sh
# Valida la estructura y componentes esenciales de la Plataforma PCD
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

BASE_DIR="/home/ppelaez/PCD-Platform"
echo "🔍 Validando estructura de la Plataforma Centralizada de Datos (PCD)..."

echo "📁 Verificando carpetas..."
REQUIRED_DIRS=(
  "$BASE_DIR/backend/api-rest"
  "$BASE_DIR/backend/websocket"
  "$BASE_DIR/backend/alerts"
  "$BASE_DIR/backend/ia/openai-proxy"
  "$BASE_DIR/backend/ia/deepseek-onprem"
  "$BASE_DIR/backend/support/passbolt"
  "$BASE_DIR/backend/support/rustdesk"
  "$BASE_DIR/backend/services/document-control"
  "$BASE_DIR/backend/services/alerts-engine"
  "$BASE_DIR/backend/services/doc-validator"
  "$BASE_DIR/backend/gateways/goodwe"
  "$BASE_DIR/backend/gateways/t301"
  "$BASE_DIR/backend/gateways/sonoff"
  "$BASE_DIR/backend/gateways/tuya"
  "$BASE_DIR/backend/gateways/schneider"
  "$BASE_DIR/backend/gateways/sigena"
  "$BASE_DIR/backend/gateways/daikin"
  "$BASE_DIR/frontend/facit"
  "$BASE_DIR/frontend/fyr"
  "$BASE_DIR/frontend/portal"
  "$BASE_DIR/kubernetes/core/postgresql"
  "$BASE_DIR/kubernetes/core/mongodb"
  "$BASE_DIR/kubernetes/core/redis"
  "$BASE_DIR/kubernetes/core/elasticsearch"
  "$BASE_DIR/kubernetes/core/kibana"
  "$BASE_DIR/kubernetes/extended/passbolt"
  "$BASE_DIR/kubernetes/extended/rustdesk"
  "$BASE_DIR/kubernetes/extended/openai-proxy"
  "$BASE_DIR/kubernetes/extended/portal"
  "$BASE_DIR/kubernetes/gateways/goodwe"
  "$BASE_DIR/kubernetes/gateways/t301"
  "$BASE_DIR/kubernetes/gateways/sonoff"
  "$BASE_DIR/kubernetes/gateways/tuya"
  "$BASE_DIR/kubernetes/gateways/schneider"
  "$BASE_DIR/kubernetes/gateways/sigena"
  "$BASE_DIR/kubernetes/gateways/daikin"
  "$BASE_DIR/kubernetes/services/document-control"
  "$BASE_DIR/kubernetes/services/alerts-engine"
  "$BASE_DIR/kubernetes/services/doc-validator"
  "$BASE_DIR/database/postgres"
  "$BASE_DIR/database/mongo"
  "$BASE_DIR/config/nginx"
  "$BASE_DIR/config/certs"
  "$BASE_DIR/config/envs"
  "$BASE_DIR/logs/api-rest"
  "$BASE_DIR/logs/websocket"
  "$BASE_DIR/logs/alerts"
  "$BASE_DIR/shared/utils"
)

for dir in "${REQUIRED_DIRS[@]}"; do
  [[ -d "$dir" ]] && echo "✔️ Existe: $dir" || echo "❌ Falta: $dir"
done

echo ""
echo "📄 Verificando archivos clave (.env, Dockerfile, main.py)..."

# Función utilitaria para validar un archivo
check_file() {
  [[ -f "$1" ]] && echo "✔️ Presente: ${1#"$BASE_DIR/"}" || echo "⚠️  Falta: ${1#"$BASE_DIR/"}"
}

# Archivos importantes a validar
check_file "$BASE_DIR/frontend/facit/.env"
check_file "$BASE_DIR/frontend/fyr/.env"
check_file "$BASE_DIR/frontend/portal/.env"
check_file "$BASE_DIR/frontend/facit/Dockerfile"
check_file "$BASE_DIR/frontend/fyr/Dockerfile"
check_file "$BASE_DIR/frontend/portal/Dockerfile"

check_file "$BASE_DIR/backend/api-rest/.env"
check_file "$BASE_DIR/backend/api-rest/main.py"
check_file "$BASE_DIR/backend/api-rest/Dockerfile"
check_file "$BASE_DIR/backend/websocket/Dockerfile"
check_file "$BASE_DIR/backend/alerts/Dockerfile"
check_file "$BASE_DIR/backend/support/passbolt/Dockerfile"
check_file "$BASE_DIR/backend/support/rustdesk/Dockerfile"
check_file "$BASE_DIR/backend/ia/openai-proxy/Dockerfile"

check_file "$BASE_DIR/backend/services/document-control/Dockerfile"
check_file "$BASE_DIR/backend/services/alerts-engine/Dockerfile"
check_file "$BASE_DIR/backend/services/doc-validator/Dockerfile"

for gw in goodwe t301 sonoff tuya schneider sigena daikin; do
  check_file "$BASE_DIR/backend/gateways/$gw/Dockerfile"
done

echo ""
echo "🔧 Comprobando versiones de software..."
echo -n "🐳 Docker: "; docker --version || echo "❌ No instalado"
echo -n "🧪 kubectl: "; kubectl version --client || echo "❌ No instalado"
echo -n "☸️  k3s: "; k3s --version || echo "❌ No instalado"
echo -n "🧬 Node.js: "; node -v || echo "❌ No instalado"
echo -n "📦 npm: "; npm -v || echo "❌ No instalado"
echo -n "🐍 Python: "; python3 --version || echo "❌ No instalado"
echo -n "🗃️ PostgreSQL: "; psql --version || echo "⚠️ No disponible localmente (OK si solo se usa en contenedor)"

echo ""
echo "✅ Validación finalizada. Revisa las advertencias para completar el entorno."

