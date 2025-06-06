#!/bin/bash
# -----------------------------------------------------------------------------
# Script 01 - Preparar entorno base en cualquier nodo (master o agente)
# Fecha: 2025-05-31
# Autor: Pedro & GPT DevOps
# -----------------------------------------------------------------------------

set -e

LOG_FILE="/home/ppelaez/scripts/prepare_env.log"
echo "⚙️ Preparando entorno base del nodo..." | tee "$LOG_FILE"

# Actualizar sistema
sudo apt-get update -y && sudo apt-get upgrade -y

# Herramientas esenciales
sudo apt-get install -y \
  curl \
  wget \
  git \
  unzip \
  gnupg2 \
  ca-certificates \
  software-properties-common \
  apt-transport-https \
  net-tools \
  lsb-release \
  build-essential

# Instalar Docker
echo "🐳 Instalando Docker..." | tee -a "$LOG_FILE"
curl -fsSL https://get.docker.com | sudo sh

# Añadir usuario actual al grupo docker
sudo usermod -aG docker $USER

# Instalar Docker Compose plugin
sudo apt-get install -y docker-compose-plugin

# Instalar Node.js 18
echo "🟢 Instalando Node.js 18..." | tee -a "$LOG_FILE"
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar Python 3.11 y pip
echo "🐍 Instalando Python 3.11 y pip..." | tee -a "$LOG_FILE"
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
sudo apt-get install -y python3-pip

# Enlace simbólico por compatibilidad
sudo ln -sf /usr/bin/python3.11 /usr/local/bin/python3
sudo ln -sf /usr/bin/pip3 /usr/local/bin/pip

# Instalar CNI plugins (solo si es master)
if [ "$HOSTNAME" = "ubuntu-32gb-nbg1-1" ]; then
  echo "🌐 Instalando CNI plugins..." | tee -a "$LOG_FILE"
  CNI_DIR="/opt/cni/bin"
  sudo mkdir -p "$CNI_DIR"
  curl -L "https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-amd64-v1.5.0.tgz" \
    | sudo tar -C "$CNI_DIR" -xz
fi

# Comprobaciones finales
echo "🔍 Verificando versiones..." | tee -a "$LOG_FILE"
docker --version | tee -a "$LOG_FILE"
docker compose version | tee -a "$LOG_FILE"
node -v | tee -a "$LOG_FILE"
python3 --version | tee -a "$LOG_FILE"
pip --version | tee -a "$LOG_FILE"

echo "✅ Entorno base preparado correctamente." | tee -a "$LOG_FILE"

