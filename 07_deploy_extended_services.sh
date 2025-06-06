#!/bin/bash

### 07_deploy_extended_services.sh
# Despliega servicios adicionales: Passbolt, RustDesk, IA y Portal Web
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e

BASE_DIR="/home/ppelaez/PCD-Platform/kubernetes/extended"
SERVICES=("passbolt" "rustdesk" "openai-proxy" "portal")

echo "🚀 Desplegando servicios extendidos..."

for SERVICE in "${SERVICES[@]}"; do
  DEPLOY_YAML="$BASE_DIR/$SERVICE/deployment.yaml"
  SERVICE_YAML="$BASE_DIR/$SERVICE/service.yaml"
  mkdir -p "$(dirname "$DEPLOY_YAML")"

  if [ ! -f "$DEPLOY_YAML" ]; then
    echo "📄 Generando $DEPLOY_YAML"
    cat <<EOF > "$DEPLOY_YAML"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $SERVICE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $SERVICE
  template:
    metadata:
      labels:
        app: $SERVICE
    spec:
      containers:
        - name: $SERVICE
          image: 10.0.0.2:5000/$SERVICE:latest
          ports:
            - containerPort: 80
EOF
  fi

  if [ ! -f "$SERVICE_YAML" ]; then
    echo "📄 Generando $SERVICE_YAML"
    cat <<EOF > "$SERVICE_YAML"
apiVersion: v1
kind: Service
metadata:
  name: $SERVICE
spec:
  type: NodePort
  selector:
    app: $SERVICE
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: $((31010 + RANDOM % 500))
EOF
  fi

  echo "📦 Aplicando $SERVICE en Kubernetes..."
  kubectl apply -f "$DEPLOY_YAML"
  kubectl apply -f "$SERVICE_YAML"
done

echo "🛠 Esperando 10 segundos para estabilizar pods..."
sleep 10
echo "📋 Estado del clúster:"
kubectl get pods -o wide
echo "📡 Servicios expuestos:"
kubectl get svc -o wide
echo "✅ Servicios extendidos desplegados correctamente."
