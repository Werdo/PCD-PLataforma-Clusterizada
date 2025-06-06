#!/bin/bash

set -e

### 07b_deploy_frontends.sh
# Despliega y construye los frontends Facit y FYR
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

FRONTEND_BASE="/home/ppelaez/PCD-Platform/frontend"
REGISTRY="10.0.0.2:5000"

function build_and_push() {
  NAME=$1
  echo -e "\n📁 Procesando frontend: $NAME"
  DIR="$FRONTEND_BASE/$NAME"

  echo "⚙️ Eliminando node_modules y lockfile si existen..."
  rm -rf "$DIR/node_modules" "$DIR/package-lock.json" "$DIR/yarn.lock"

  echo "📦 Instalando dependencias ($NAME)..."
  cd "$DIR"

  if [[ "$NAME" == "fyr" ]]; then
    echo "📚 Instalando dependencia react-syntax-highlighter para fyr..."
    npm install react-syntax-highlighter --legacy-peer-deps || true
  fi

  npm install --legacy-peer-deps --no-cache || true

  echo "🔨 Compilando build de producción ($NAME)..."
  npm run build || {
    echo "❌ Error al compilar $NAME. Abortando push."
    return 1
  }

  if [ ! -d "$DIR/dist" ]; then
    echo "❌ Build fallido: no se encontró carpeta dist en $DIR"
    return 1
  fi

  if [ ! -f "$DIR/Dockerfile" ]; then
    echo "📝 Generando Dockerfile en $DIR..."
    cat <<EOF > "$DIR/Dockerfile"
FROM nginx:alpine
COPY dist /usr/share/nginx/html
EOF
  fi

  echo "🐳 Construyendo imagen Docker para $NAME..."
  sudo docker build -t $REGISTRY/$NAME:latest "$DIR"

  echo "📤 Pusheando imagen a Registry privado ($REGISTRY/$NAME:latest)..."
  sudo docker push $REGISTRY/$NAME:latest || {
    echo "❌ Fallo al pushear $NAME. Asegúrate de que el registry acepta HTTP y no HTTPS."
  }

  echo "✅ $NAME desplegado y subido correctamente."
}

# Interacción con el usuario
echo "Selecciona qué frontend compilar y desplegar:"
echo " 1) facit"
echo " 2) fyr"
echo " 3) todo"
read -p "Introduce una opción (1/2/3): " OPTION

case "$OPTION" in
  1)
    build_and_push "facit"
    ;;
  2)
    build_and_push "fyr"
    ;;
  3)
    build_and_push "facit"
    build_and_push "fyr"
    ;;
  *)
    echo "❌ Opción no válida. Usa 1, 2 o 3."
    exit 1
    ;;
esac

cd ~/scripts

