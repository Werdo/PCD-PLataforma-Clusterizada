#!/bin/bash

# 05_deploy_kubernetes.sh
# Función: Crea estructura y despliega los frontends Facit y FYR en el clúster K3s
# Autor: Pedro / ChatGPT - Fecha: 2025-06-04

set -e

echo "📁 Creando estructura de carpetas K8s..."
mkdir -p /home/ppelaez/PCD-Platform/k8s/frontend/facit
mkdir -p /home/ppelaez/PCD-Platform/k8s/frontend/fyr

echo "📄 Generando archivos YAML para Facit..."

cat <<EOF > /home/ppelaez/PCD-Platform/k8s/frontend/facit/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: facit-frontend
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: facit
  template:
    metadata:
      labels:
        app: facit
    spec:
      containers:
      - name: facit
        image: 10.0.0.2:5000/facit:latest
        ports:
        - containerPort: 80
EOF

cat <<EOF > /home/ppelaez/PCD-Platform/k8s/frontend/facit/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: facit-service
  namespace: default
spec:
  type: NodePort
  selector:
    app: facit
  ports:
    - port: 80
      targetPort: 80
      nodePort: 31001
EOF

echo "📄 Generando archivos YAML para FYR..."

cat <<EOF > /home/ppelaez/PCD-Platform/k8s/frontend/fyr/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fyr-frontend
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fyr
  template:
    metadata:
      labels:
        app: fyr
    spec:
      containers:
      - name: fyr
        image: 10.0.0.2:5000/fyr:latest
        ports:
        - containerPort: 80
EOF

cat <<EOF > /home/ppelaez/PCD-Platform/k8s/frontend/fyr/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: fyr-service
  namespace: default
spec:
  type: NodePort
  selector:
    app: fyr
  ports:
    - port: 80
      targetPort: 80
      nodePort: 31002
EOF

echo "🚀 Aplicando despliegue en Kubernetes..."
kubectl apply -f /home/ppelaez/PCD-Platform/k8s/frontend/facit/deployment.yaml
kubectl apply -f /home/ppelaez/PCD-Platform/k8s/frontend/facit/service.yaml

kubectl apply -f /home/ppelaez/PCD-Platform/k8s/frontend/fyr/deployment.yaml
kubectl apply -f /home/ppelaez/PCD-Platform/k8s/frontend/fyr/service.yaml

echo "✅ Despliegue completo de Facit y FYR."

