#!/bin/bash
# 07a_prepare_frontends.sh
# Autor: Pedro P.
# Fecha: 2025-05-31
# Descripción: Prepara y descomprime los frontends facit y fyr en sus carpetas correspondientes.

set -e

echo "🗖️ Preparando estructura de frontends..."

# Crear estructura base si no existe
mkdir -p /home/ppelaez/PCD-Platform/frontend/facit
mkdir -p /home/ppelaez/PCD-Platform/frontend/fyr

# Descomprimir facit
echo "📁 Descomprimiendo facit-vite.zip..."
unzip -o facit-vite.zip -d /home/ppelaez/PCD-Platform/frontend/facit-tmp > /dev/null 2>&1
mv /home/ppelaez/PCD-Platform/frontend/facit-tmp/* /home/ppelaez/PCD-Platform/frontend/facit/ || true
rm -rf /home/ppelaez/PCD-Platform/frontend/facit-tmp

# Descomprimir fyr
echo "📁 Descomprimiendo fyr-vite.zip..."
unzip -o fyr-vite.zip -d /home/ppelaez/PCD-Platform/frontend/fyr-tmp > /dev/null 2>&1
mv /home/ppelaez/PCD-Platform/frontend/fyr-tmp/* /home/ppelaez/PCD-Platform/frontend/fyr/ || true
rm -rf /home/ppelaez/PCD-Platform/frontend/fyr-tmp

# Validación de facit
echo -n "✅ Comprobando estructura de facit... "
if [[ -f /home/ppelaez/PCD-Platform/frontend/facit/package.json && \
      -f /home/ppelaez/PCD-Platform/frontend/facit/vite.config.mts ]]; then
    echo "✔️"
else
    echo "❌ Archivos principales no encontrados en /home/ppelaez/PCD-Platform/frontend/facit"
    exit 1
fi

# Validación de fyr
echo -n "✅ Comprobando estructura de fyr... "
if [[ -f /home/ppelaez/PCD-Platform/frontend/fyr/package.json && \
      -f /home/ppelaez/PCD-Platform/frontend/fyr/vite.config.ts ]]; then
    echo "✔️"
else
    echo "❌ Archivos principales no encontrados en /home/ppelaez/PCD-Platform/frontend/fyr"
    exit 1
fi

echo "✅ Frontends preparados correctamente."
