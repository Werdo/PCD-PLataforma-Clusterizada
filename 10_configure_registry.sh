#!/bin/bash
# -----------------------------------------------------------------------------
# Script 10 - Configurar K3s para confiar en el Docker Registry privado
# Dirección del registry: 10.0.0.2:5000
# Fecha: 2025-05-31
# -----------------------------------------------------------------------------

REG_FILE="/etc/rancher/k3s/registries.yaml"

echo "🛠 Configurando registry privado en K3s..."

sudo mkdir -p /etc/rancher/k3s/

sudo tee $REG_FILE > /dev/null <<EOF
mirrors:
  "10.0.0.2:5000":
    endpoint:
      - "http://10.0.0.2:5000"
EOF

echo "✅ Archivo creado: $REG_FILE"
echo "🔄 Reiniciando K3s para aplicar configuración..."

sudo systemctl restart k3s

echo "✅ K3s reiniciado y listo para usar el registry privado 10.0.0.2:5000"

