#!/bin/bash

# Script: 20_generate_fyr_facit_modules.sh
# Descripción: Genera los módulos de integración FYR y Facit conectados a las APIs PCD
# Autor: Pedro P.
# Fecha: 2025-06-04

set -e

BASE_DIR="/home/ppelaez/PCD-Platform/frontend"
MOD_FYR="$BASE_DIR/fyr/modules"
MOD_FACIT="$BASE_DIR/facit/modules"
API_DIR="api"
PAGES_DIR="pages"
COMP_DIR="components"

MODULES=(
  users devices sensors readings \
  energy climate lighting access alerts \
  documentControl validation production gatewayEvents
)

echo "📁 Generando estructura de módulos para FYR y Facit..."

for TARGET in "$MOD_FYR" "$MOD_FACIT"; do
  mkdir -p "$TARGET/$API_DIR" "$TARGET/$PAGES_DIR" "$TARGET/$COMP_DIR"
  for mod in "${MODULES[@]}"; do
    echo "🔄 Generando módulo: $mod en $(basename $TARGET)..."

    # Archivo API
    cat <<EOF > "$TARGET/$API_DIR/$mod.ts"
import axios from 'axios'

export async function getAll${mod^}() {
  const response = await axios.get(`/api/$mod`)
  return response.data
}
EOF

    # Archivo Page
    cat <<EOF > "$TARGET/$PAGES_DIR/$mod.tsx"
import { useEffect, useState } from 'react'
import { getAll${mod^} } from '../api/$mod'

export default function ${mod^}Page() {
  const [data, setData] = useState([])

  useEffect(() => {
    getAll${mod^}().then(setData)
  }, [])

  return (
    <div>
      <h1 className="text-2xl font-bold">$mod</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  )
}
EOF

    # Archivo Componente
    cat <<EOF > "$TARGET/$COMP_DIR/${mod^}List.tsx"
interface Props {
  data: any[]
}

export function ${mod^}List({ data }: Props) {
  return (
    <ul>
      {data.map((item, i) => (
        <li key={i}>{JSON.stringify(item)}</li>
      ))}
    </ul>
  )
}
EOF

  done
  echo "✅ $(basename $TARGET): todos los módulos generados."
done

echo "🚀 Módulos FYR y Facit generados en: $MOD_FYR y $MOD_FACIT"
