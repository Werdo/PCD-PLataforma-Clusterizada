# 🤖 Document Validator – Validación de Documentación con IA

El microservicio `doc-validator` analiza documentos cargados en la Plataforma Centralizada de Datos (PCD) mediante OCR e inteligencia artificial básica. Su objetivo es validar la autenticidad, integridad y cumplimiento de los documentos asociados a proveedores o clientes.

---

## 🎯 Funcionalidades

- Análisis OCR de documentos (PDF, imagen)
- Validación de texto por reglas internas
- Retorno inmediato de estado del documento (válido / inválido)
- Integración directa con `document-control`
- Generación automática de alertas si se detectan errores

---

## 📦 Endpoints (FastAPI)

### 📄 Validar documento

| Método | Ruta       | Descripción                      |
|--------|------------|----------------------------------|
| POST   | `/validate`| Recibe archivo, ejecuta OCR y valida contenido |

```bash
curl -F "file=@certificado.jpg" http://localhost:8092/validate
```

### 🧾 Respuesta

```json
{
  "filename": "certificado.jpg",
  "valid": false,
  "issues": [
    "Falta la palabra 'certificado'",
    "No se detecta ninguna fecha válida"
  ]
}
```

---

## 🧠 Reglas de validación implementadas

- El texto debe contener palabras clave como `certificado`, `validado`, etc.
- Se debe detectar una fecha (ej. "2024", "2025", etc.)
- Las reglas son extensibles a patrones específicos, sellos digitales o contenido normativo

---

## 🛠️ Despliegue

### Dockerfile

```dockerfile
FROM python:3.11-slim
RUN apt-get update && apt-get install -y tesseract-ocr libglib2.0-0 libsm6 libxrender1 libxext6 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8092"]
```

### Requisitos adicionales

- Tesseract OCR (instalado en imagen)
- Puerto: `8092`

---

## 🤝 Integraciones

- Se activa desde `document-control` automáticamente al subir un documento
- Si se detectan problemas, lanza una alerta hacia `alerts-engine`
- Compatible con control manual desde FYR (checklist extendida)

---

Este microservicio es clave para garantizar el cumplimiento documental de los proveedores y automatizar el proceso de control de calidad de documentos.