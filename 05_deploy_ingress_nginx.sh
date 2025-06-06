#!/bin/bash
# Despliegue del Ingress Controller nginx en K3s
# Autor: Pedro / ChatGPT | Fecha: 2025-05-31

set -e

echo "🌐 Desplegando ingress-nginx en el clúster..."

# Crear namespace
kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

# Descargar y aplicar manifiesto base
kubectl apply -n ingress-nginx -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/cloud/deploy.yaml

# Esperar 10s para asegurar que los recursos se crean
sleep 10

# Parchear el servicio para que sea accesible desde fuera (NodePort)
kubectl patch svc ingress-nginx-controller \
  -n ingress-nginx \
  -p '{"spec": {"type": "NodePort"}}'

echo "✅ Ingress nginx desplegado como NodePort."
kubectl get svc -n ingress-nginx

