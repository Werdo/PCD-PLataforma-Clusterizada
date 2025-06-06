#!/bin/bash

echo "⚠️ ATENCIÓN: Este script eliminará completamente la Plataforma PCD"
read -p "¿Estás seguro de continuar? (s/N): " confirm
if [[ "$confirm" != "s" ]]; then
  echo "❌ Cancelado."
  exit 1
fi

echo "🧹 Borrando despliegues, servicios y recursos..."
kubectl delete all --all -n default
kubectl delete all --all -n support
kubectl delete all --all -n kube-system
kubectl delete pvc --all -A
kubectl delete configmap --all -A
kubectl delete secrets --all -A
kubectl delete ingress --all -A

echo "🗑️ Eliminando carpetas de la plataforma..."
rm -rf /home/ppelaez/PCD-Platform

echo "✅ Plataforma borrada. Puedes volver a desplegar desde el script maestro."
