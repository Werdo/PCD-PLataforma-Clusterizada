#!/bin/bash
# 18_generate_visual_modules.sh
# Crea módulos de visualización para FYR y FACIT en la plataforma PCD.

BASE_DIR="/home/ppelaez/PCD-Platform"
MOD_NAMES=("energy" "lighting" "access" "automation" "climate" "alerts" "traces" "databases")

echo "🧩 Generando módulos de visualización para FYR y FACIT..."

for FRONTEND in fyr facit; do
  MODULE_PATH="$BASE_DIR/frontend/$FRONTEND/src/modules"
  mkdir -p "$MODULE_PATH"
  for MOD in "${MOD_NAMES[@]}"; do
    FILE="$MODULE_PATH/${MOD}.tsx"
    if [[ ! -f "$FILE" ]]; then
      echo "📄 Creando módulo: $FILE"
      cat <<EOF > "$FILE"
import React from "react";

const ${MOD^}Module = () => {
  return (
    <div>
      <h1 className="text-2xl font-bold text-center mt-10">${MOD^} Module</h1>
      <p className="text-center mt-2">Este módulo mostrará visualizaciones relacionadas con ${MOD}.</p>
    </div>
  );
};

export default ${MOD^}Module;
EOF
    fi
  done
done

echo "✅ Módulos de visualización generados correctamente para FYR y FACIT."
"""

# Guardar el script
script_path = Path("/mnt/data/18_generate_visual_modules.sh")
script_path.write_text(script_content)
script_path.chmod(0o755)
script_path

Analizado
python
Mostrar siempre los detalles

Copiar
from pathlib import Path

# Script de generación de módulos de visualización para FYR y FACIT
script_content = """#!/bin/bash
# 18_generate_visual_modules.sh
# Crea módulos de visualización para FYR y FACIT en la plataforma PCD.

BASE_DIR="/home/ppelaez/PCD-Platform"
MOD_NAMES=("energy" "lighting" "access" "automation" "climate" "alerts" "traces" "databases")

echo "🧩 Generando módulos de visualización para FYR y FACIT..."

for FRONTEND in fyr facit; do
  MODULE_PATH="$BASE_DIR/frontend/$FRONTEND/src/modules"
  mkdir -p "$MODULE_PATH"
  for MOD in "${MOD_NAMES[@]}"; do
    FILE="$MODULE_PATH/${MOD}.tsx"
    if [[ ! -f "$FILE" ]]; then
      echo "📄 Creando módulo: $FILE"
      cat <<EOF > "$FILE"
import React from "react";

const ${MOD^}Module = () => {
  return (
    <div>
      <h1 className="text-2xl font-bold text-center mt-10">${MOD^} Module</h1>
      <p className="text-center mt-2">Este módulo mostrará visualizaciones relacionadas con ${MOD}.</p>
    </div>
  );
};

export default ${MOD^}Module;
EOF
    fi
  done
done

echo "✅ Módulos de visualización generados correctamente para FYR y FACIT."
