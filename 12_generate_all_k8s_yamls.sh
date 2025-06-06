#!/bin/bash

### 12_generate_all_k8s_yamls.sh
# Genera todos los archivos YAML (deployment y service) para los servicios core y extendidos de la PCD
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e

K8S_BASE="/home/ppelaez/PCD-Platform/kubernetes"

declare -A SERVICES=(
  # Core
  ["postgresql"]="5432"
  ["mongodb"]="27017"
  ["redis"]="6379"
  ["elasticsearch"]="9200"
  ["kibana"]="5601"
  # Extendidos
  ["passbolt"]="80"
  ["rustdesk"]="80"
  ["openai-proxy"]="80"
  ["portal"]="80"
  # Frontends
  ["facit"]="80"
  ["fyr"]="80"
  # Backend microservicios
  ["api-rest"]="8000"
  ["websocket"]="8001"
  ["alerts"]="8002"
)

function generate_yaml() {
  local name=$1
  local port=$2
  local type=$3
  local target_path="$K8S_BASE/$type/$name"

  mkdir -p "$target_path"

  if [ ! -f "$target_path/deployment.yaml" ]; then
    echo "📄 Generando $target_path/deployment.yaml"
    cat <<EOF > "$target_path/deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $name
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $name
  template:
    metadata:
      labels:
        app: $name
    spec:
      containers:
        - name: $name
          image: 10.0.0.2:5000/$name:latest
          ports:
            - containerPort: $port
EOF
  fi

  if [ ! -f "$target_path/service.yaml" ]; then
    echo "📄 Generando $target_path/service.yaml"
    cat <<EOF > "$target_path/service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: $name
spec:
  type: NodePort
  selector:
    app: $name
  ports:
    - protocol: TCP
      port: $port
      targetPort: $port
      nodePort: 3$((1000 + RANDOM % 8999))
EOF
  fi
}

echo "🛠 Generando todos los YAML de Kubernetes..."

for service in "${!SERVICES[@]}"; do
  port="${SERVICES[$service]}"
  if [[ "$service" == "postgresql" || "$service" == "mongodb" || "$service" == "redis" || "$service" == "elasticsearch" || "$service" == "kibana" ]]; then
    generate_yaml "$service" "$port" "core"
  elif [[ "$service" == "facit" || "$service" == "fyr" || "$service" == "portal" ]]; then
    generate_yaml "$service" "$port" "frontend"
  elif [[ "$service" == "api-rest" || "$service" == "websocket" || "$service" == "alerts" ]]; then
    generate_yaml "$service" "$port" "backend"
  else
    generate_yaml "$service" "$port" "extended"
  fi
done

echo "✅ Todos los YAML generados correctamente."

