#!/bin/bash

# Autor: Pedro Peláez
# Fecha: 2025-06-04
# Descripción: Genera estructura de módulos para FYR y Facit conectados a las APIs backend

BASE_DIR="/home/ppelaez/PCD-Platform"
FRONTENDS=("fyr" "facit")
MODULOS=(
  "api-rest"
  "websocket"
  "alerts"
  "document-control"
  "alerts-engine"
  "doc-validator"
  "goodwe"
  "t301"
  "sonoff"
  "tuya"
  "schneider"
  "sigena"
  "daikin"
)

echo "🛠️ Generando estructura de módulos para FYR y Facit..."

for FRONT in "${FRONTENDS[@]}"; do
  FRONT_PATH="$BASE_DIR/frontend/$FRONT"
  for MOD in "${MODULOS[@]}"; do
    MODULE_NAME=$(echo "$MOD" | sed 's/-/_/g')
    COMPONENTS_DIR="$FRONT_PATH/modules/$MODULE_NAME/components"
    PAGES_DIR="$FRONT_PATH/modules/$MODULE_NAME/pages"
    API_DIR="$FRONT_PATH/modules/$MODULE_NAME/api"

    mkdir -p "$COMPONENTS_DIR" "$PAGES_DIR" "$API_DIR"

    # README base
    echo "# Módulo $MODULE_NAME para $FRONT" > "$FRONT_PATH/modules/$MODULE_NAME/README.md"
    echo "✔️ Creado: $FRONT/modules/$MODULE_NAME"
  done
done

echo "✅ Estructura de módulos completada para FYR y Facit."

