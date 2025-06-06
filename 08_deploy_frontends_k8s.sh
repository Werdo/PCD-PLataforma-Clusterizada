#!/bin/bash

### 08_deploy_frontends_k8s.sh
# Despliega los frontends facit y fyr en el clúster Kubernetes desde el Docker Registry privado
# Autor: Pedro / ChatGPT
# Fecha: 2025-05-31

set -e

REGISTRY="10.0.0.2:5000"
NAMESPACE="frontend"

FRONTENDS=("facit" "fyr")

echo "🚀 Desplegando frontends en Kubernetes..."

# Crear namespace si no existe
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || {
  echo "📦 Creando namespace $NAMESPACE..."
  kubectl create namespace $NAMESPACE
}

for APP in "${FRONTENDS[@]}"; do
  echo "\n🔧 Desplegando $APP..."

  # Rutas
  YAML_DIR="/home/ppelaez/PCD-Platform/k8s/$APP"
  mkdir -p "$YAML_DIR"

  # Archivo deployment.yaml
  cat <<EOF > "$YAML_DIR/deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $APP
  template:
    metadata:
      labels:
        app: $APP
    spec:
      containers:
      - name: $APP
        image: $REGISTRY/$APP:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
EOF

  # Archivo service.yaml
  cat <<EOF > "$YAML_DIR/service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: $APP-service
  namespace: $NAMESPACE
spec:
  selector:
    app: $APP
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: $((30000 + RANDOM % 1000))
EOF

  # Aplicar YAMLs
  kubectl apply -f "$YAML_DIR/deployment.yaml"
  kubectl apply -f "$YAML_DIR/service.yaml"

  echo "✅ $APP desplegado en namespace $NAMESPACE."
done

echo "🏁 Frontends desplegados correctamente."
exit 0

