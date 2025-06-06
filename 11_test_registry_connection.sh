#!/bin/bash
# -----------------------------------------------------------------------------
# Script 11 - Verificar acceso al Docker Registry privado (10.0.0.2:5000)
# -----------------------------------------------------------------------------

echo "🔍 Comprobando acceso al registry privado 10.0.0.2:5000..."

if curl -s http://10.0.0.2:5000/v2/_catalog; then
  echo "✅ Conexión exitosa al Docker Registry."
else
  echo "❌ Error al conectar con el Docker Registry."
  exit 1
fi

