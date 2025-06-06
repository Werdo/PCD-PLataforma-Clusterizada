#!/bin/bash

### 06b_expose_core_services.sh
# Expone servicios core como NodePort para acceso externo
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e
BASE="/home/ppelaez/PCD-Platform/kubernetes/core"

declare -A services
services["postgresql"]="5432:31532"
services["mongodb"]="27017:31017"
services["redis"]="6379:30679"
services["elasticsearch"]="9200:31920"
services["kibana"]="5601:31601"

for svc in "${!services[@]}"; do
  PORTS="${services[$svc]}"
  PORT="${PORTS%%:*}"
  NODEPORT="${PORTS##*:}"

  echo "📄 Regenerando servicio $svc como NodePort..."

  YAML_PATH="$BASE/$svc/service.yaml"
  mkdir -p "$BASE/$svc"

  cat > "$YAML_PATH" <<EOF
apiVersion: v1
kind: Service
metadata:
  name: $svc
spec:
  type: NodePort
  selector:
    app: $svc
  ports:
    - protocol: TCP
      port: $PORT
      targetPort: $PORT
      nodePort: $NODEPORT
EOF

  echo "📦 Aplicando servicio $svc en Kubernetes..."
  kubectl apply -f "$YAML_PATH"
done

echo "✅ Todos los servicios core expuestos como NodePort."

