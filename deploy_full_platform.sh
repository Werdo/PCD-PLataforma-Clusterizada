#!/bin/bash

# deploy_full_platform.sh
# Automatiza el despliegue completo de la PCD
# Autor: Pedro / ChatGPT
# Fecha: 2025-06-04

set -e

# 1. Preparar estructura de carpetas
./04_organize_files.sh

# 2. Generar módulos para FYR y Facit
./18_generate_fyr_facit_modules.sh
./18_generate_visual_modules.sh

# 3. Construir y subir todas las imágenes de backend y gateways
./build_all_and_push.sh

# 4. Aplicar manifiestos de los gateways
for GW_DIR in gateways/*; do
  [ -d "$GW_DIR" ] || continue
  echo "\n🚀 Desplegando gateway $(basename "$GW_DIR")..."
  for FILE in deployment.yaml service.yaml ingress.yaml; do
    if [ -f "$GW_DIR/$FILE" ]; then
      kubectl apply -f "$GW_DIR/$FILE"
    fi
  done
done

# 5. Construir y subir los frontends
# Seleccionamos la opción 'todo' (3) de manera no interactiva
printf "3\n" | ./07b_deploy_frontends.sh

# 6. Desplegar frontends en Kubernetes
./08_deploy_frontends_k8s.sh

echo "\n🏁 Plataforma desplegada por completo."
