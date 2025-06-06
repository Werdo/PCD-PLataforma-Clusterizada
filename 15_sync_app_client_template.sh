#!/bin/bash

set -e

### 15_sync_app_client_template.sh
# Construye, empaqueta y despliega el frontend "fyr" como servicio en Kubernetes
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

APP_NAME="fyr"
FRONTEND_DIR="/home/ppelaez/PCD-Platform/frontend/$APP_NAME"
REGISTRY="10.0.0.2:5000"
NAMESPACE="frontend"

if [[ ! -d "$FRONTEND_DIR" ]]; then
  echo "❌ No se encuentra el directorio $FRONTEND_DIR"
  exit 1
fi

cd "$FRONTEND_DIR"

echo "🧹 Limpiando dependencias anteriores..."
rm -rf node_modules package-lock.json dist

echo "📦 Instalando dependencias para $APP_NAME..."
npm install --legacy-peer-deps --no-cache

echo "🔨 Compilando build de producción para $APP_NAME..."
npm run build

echo "🐳 Construyendo imagen Docker para $APP_NAME..."
sudo docker build -t $REGISTRY/$APP_NAME:latest .

echo "📤 Pusheando imagen a Registry privado ($REGISTRY/$APP_NAME)..."
sudo docker push $REGISTRY/$APP_NAME:latest || {
  echo "❌ Error al pushear la imagen."
  exit 1
}

echo "📦 Generando manifiesto de despliegue para Kubernetes..."
MANIFEST_PATH="/home/ppelaez/PCD-Platform/k8s/deployments/deployment-$APP_NAME.yaml"

cat <<EOF | tee "$MANIFEST_PATH"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP_NAME
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $APP_NAME
  template:
    metadata:
      labels:
        app: $APP_NAME
    spec:
      containers:
        - name: $APP_NAME
          image: $REGISTRY/$APP_NAME:latest
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: $APP_NAME
  namespace: $NAMESPACE
spec:
  type: NodePort
  selector:
    app: $APP_NAME
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30303
EOF

echo "☸️ Aplicando manifiesto con kubectl..."
kubectl apply -f "$MANIFEST_PATH"

echo "✅ Frontend $APP_NAME desplegado en Kubernetes en el namespace '$NAMESPACE'."

