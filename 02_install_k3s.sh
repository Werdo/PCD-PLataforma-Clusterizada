#!/bin/bash
# -----------------------------------------------------------------------------
# Script 02 - Instalar K3s (solo nodo principal / control-plane)
# Fecha: 2025-05-31
# Autor: Pedro & GPT DevOps
# -----------------------------------------------------------------------------

set -e

LOG_FILE="/home/ppelaez/scripts/install_k3s.log"
echo "☸️ Instalando K3s en modo servidor (control-plane)..." | tee "$LOG_FILE"

# Instalar K3s con soporte para flannel, containerd y acceso externo
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --node-ip=$(hostname -I | awk '{print $1}')" sh -s - >> "$LOG_FILE" 2>&1

# Mostrar estado
echo "🕵️ Verificando estado del servicio k3s..." | tee -a "$LOG_FILE"
sudo systemctl status k3s --no-pager | tee -a "$LOG_FILE"

# Mostrar token para nodos agentes
TOKEN_PATH="/var/lib/rancher/k3s/server/node-token"
if [ -f "$TOKEN_PATH" ]; then
  TOKEN=$(sudo cat "$TOKEN_PATH")
  IP=$(hostname -I | awk '{print $1}')
  echo "✅ K3s instalado correctamente."
  echo "👉 Ejecuta este comando en los AGENTES para unirlos al clúster:" | tee -a "$LOG_FILE"
  echo ""
  echo "  curl -sfL https://get.k3s.io | K3S_URL=https://$IP:6443 K3S_TOKEN=$TOKEN sh -s -"
  echo ""
else
  echo "❌ No se pudo encontrar el token de K3s. Algo falló." | tee -a "$LOG_FILE"
  exit 1
fi

