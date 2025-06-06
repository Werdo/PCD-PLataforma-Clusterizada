#!/bin/bash

set -e
echo "🧹 Iniciando limpieza de servicios problemáticos..."

# Ruta base
BASE_DIR="/home/ppelaez/PCD-Platform"

# 1. Eliminar Dockerfile de servicios que no deben tener build tipo Nginx
for service in support/passbolt ia/openai-proxy support/rustdesk; do
  DOCKERFILE="$BASE_DIR/backend/$service/Dockerfile"
  if [[ -f "$DOCKERFILE" ]]; then
    echo "🗑️ Eliminando Dockerfile innecesario: $DOCKERFILE"
    rm "$DOCKERFILE"
  fi
done

# 2. Eliminar requirements.txt inválidos para regenerar bien
for broken_service in alerts gateways/t301; do
  REQ="$BASE_DIR/backend/$broken_service/requirements.txt"
  if [[ -f "$REQ" ]]; then
    echo "🗑️ Eliminando requirements.txt corrupto: $REQ"
    rm "$REQ"
  fi
done

echo "✅ Limpieza completada. Ahora puedes ejecutar:"
echo "   ./04_organize_files.sh"
echo "   ./build_all_and_push.sh"

