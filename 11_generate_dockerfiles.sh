#!/bin/bash

set -e

### 11_generate_dockerfiles.sh
# Genera los Dockerfiles base para los frontends facit y fyr
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

BASE_DIR="/home/ppelaez/PCD-Platform/frontend"
FRONTENDS=(facit fyr)

echo "🔧 Generando Dockerfiles para frontends..."

for frontend in "${FRONTENDS[@]}"; do
  TARGET_DIR="$BASE_DIR/$frontend"
  DOCKERFILE="$TARGET_DIR/Dockerfile"

  if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Carpeta no encontrada: $TARGET_DIR. Omite $frontend."
    continue
  fi

  echo "📝 Generando Dockerfile para $frontend en $TARGET_DIR..."
  cat <<EOF > "$DOCKERFILE"
FROM nginx:alpine
COPY dist /usr/share/nginx/html
EOF
  echo "✅ Dockerfile generado para $frontend."
done

echo "🏁 Finalizado."
exit 0

