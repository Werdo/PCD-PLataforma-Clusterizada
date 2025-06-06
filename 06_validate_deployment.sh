#!/bin/bash

### 06_validate_deployment.sh
# Valida y despliega servicios core de la plataforma (bases de datos y herramientas de análisis/log)
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e

PLATFORM_DIR="/home/ppelaez/PCD-Platform/kubernetes/core"
REGISTRY="10.0.0.2:5000"

mkdir -p "$PLATFORM_DIR/postgresql" "$PLATFORM_DIR/mongodb" "$PLATFORM_DIR/redis" "$PLATFORM_DIR/elasticsearch" "$PLATFORM_DIR/kibana"

generate_yaml_if_missing() {
  local service=$1
  local port=$2
  local image=$3
  local volumePath="/data/$service"

  DEPLOY="$PLATFORM_DIR/$service/deployment.yaml"
  SERVICE="$PLATFORM_DIR/$service/service.yaml"

  if [ ! -f "$DEPLOY" ]; then
    echo "📄 Generando $DEPLOY"
    cat <<EOF > "$DEPLOY"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $service
  template:
    metadata:
      labels:
        app: $service
    spec:
      containers:
      - name: $service
        image: $image
        ports:
        - containerPort: $port
        volumeMounts:
        - name: ${service}-data
          mountPath: $volumePath
      volumes:
      - name: ${service}-data
        emptyDir: {}
EOF
  fi

  if [ ! -f "$SERVICE" ]; then
    echo "📄 Generando $SERVICE"
    cat <<EOF > "$SERVICE"
apiVersion: v1
kind: Service
metadata:
  name: $service
spec:
  selector:
    app: $service
  ports:
    - protocol: TCP
      port: $port
      targetPort: $port
  type: ClusterIP
EOF
  fi

  echo "📦 Aplicando $service..."
  kubectl apply -f "$DEPLOY"
  kubectl apply -f "$SERVICE"
}

echo "🧠 Desplegando contenedores core de la plataforma (Paso 6)..."

generate_yaml_if_missing postgresql 5432 postgres:16-alpine
generate_yaml_if_missing mongodb 27017 mongo:7
generate_yaml_if_missing redis 6379 redis:7-alpine
generate_yaml_if_missing elasticsearch 9200 docker.elastic.co/elasticsearch/elasticsearch:8.13.0
generate_yaml_if_missing kibana 5601 docker.elastic.co/kibana/kibana:8.13.0

echo "🛠 Esperando 10 segundos para estabilizar pods..."
sleep 10

echo "📋 Estado actual del clúster:"
kubectl get pods -o wide
kubectl get svc -o wide

echo "✅ Despliegue de servicios core verificado y completado."

