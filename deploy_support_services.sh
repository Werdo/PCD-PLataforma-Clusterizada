#!/bin/bash
# Autor: Pedro Peláez
# Fecha: 2025-06-04
# Descripción: Despliega y genera manifiestos para Passbolt y RustDesk en el namespace "support"

set -e

BASE_DIR="/home/ppelaez/PCD-Platform/kubernetes/extended"
NAMESPACE="support"

echo "☸️ Creando namespace '$NAMESPACE' si no existe..."
kubectl get ns $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

generate_yaml_files() {
  local SERVICE=$1
  local DIR="$BASE_DIR/$SERVICE"
  local IMAGE="10.0.0.2:5000/$SERVICE:latest"

  mkdir -p "$DIR"

  if [[ ! -f "$DIR/deployment.yaml" ]]; then
    echo "⚙️ Generando $SERVICE/deployment.yaml"
    cat > "$DIR/deployment.yaml" <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $SERVICE
  namespace: $NAMESPACE
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
        image: $IMAGE
        ports:
        - containerPort: 80
EOF
  fi

  if [[ ! -f "$DIR/service.yaml" ]]; then
    echo "⚙️ Generando $SERVICE/service.yaml"
    cat > "$DIR/service.yaml" <<EOF
apiVersion: v1
kind: Service
metadata:
  name: $SERVICE-service
  namespace: $NAMESPACE
spec:
  selector:
    app: $SERVICE
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
EOF
  fi

  if [[ ! -f "$DIR/ingress.yaml" ]]; then
    echo "⚙️ Generando $SERVICE/ingress.yaml"
    cat > "$DIR/ingress.yaml" <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: $SERVICE-ingress
  namespace: $NAMESPACE
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: $SERVICE.pcd.plataforma.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: $SERVICE-service
            port:
              number: 80
EOF
  fi
}

for SERVICE in passbolt rustdesk; do
  echo "🔧 Preparando $SERVICE..."
  generate_yaml_files "$SERVICE"

  echo "🚀 Aplicando manifiestos de $SERVICE..."
  kubectl apply -f "$BASE_DIR/$SERVICE/deployment.yaml"
  kubectl apply -f "$BASE_DIR/$SERVICE/service.yaml"
  kubectl apply -f "$BASE_DIR/$SERVICE/ingress.yaml"
  echo "✅ $SERVICE desplegado."
done

echo "🏁 Despliegue completo de servicios de soporte."

