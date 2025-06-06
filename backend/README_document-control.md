# 📁 Document Control – Gestión de Documentación de Proveedores

Este microservicio forma parte de la Plataforma Centralizada de Datos (PCD) y está diseñado para gestionar la documentación, certificaciones y validación de proveedores y clientes.

---

## 🎯 Funcionalidades

- Registro de proveedores
- Gestión de documentos asociados a cada proveedor
- Control de vencimiento de documentos
- Categorización por tipo de documento y origen (manual / automático)
- Validación automática de documentos con IA (via `doc-validator`)
- Generación de alertas en caso de documentos inválidos o vencidos (via `alerts-engine`)
- Importación masiva desde archivos CSV
- Visualización e interacción desde FYR

---

## 🔧 Endpoints principales (FastAPI)

| Método | Ruta                        | Descripción                                      |
|--------|-----------------------------|--------------------------------------------------|
| GET    | `/proveedores`             | Listado de proveedores registrados               |
| POST   | `/proveedores`             | Alta de proveedor                                |
| GET    | `/documentos`              | Listado de documentos cargados                   |
| POST   | `/documentos`              | Subida de documento + validación automática      |
| POST   | `/import-csv`              | Carga masiva de documentos y datos desde CSV     |
| GET    | `/certificaciones`         | Listado de certificaciones por proveedor         |
| POST   | `/certificaciones`         | Alta de certificación                            |

---

## 🤖 Integración IA

Cada documento subido se valida automáticamente con el microservicio `doc-validator`:

- Se extrae texto con OCR
- Se validan reglas básicas (presencia de campos, fechas, palabras clave)
- Si falla → se lanza alerta hacia `alerts-engine`

---

## 📦 Docker & Kubernetes

### Dockerfile incluido

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8091"]
```

### Variables de entorno

```env
PORT=8091
```

### Kubernetes (ejemplo de deployment y service)

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

---

## 🌐 Integración con FYR

El componente `ProveedorAlertView` en FYR permite:

- Ver proveedores y documentos con alertas visuales
- Subir documentos y validarlos desde la interfaz
- Importar CSV
- Interacción en tiempo real vía WebSocket con `alerts-engine`

---

## 📁 Archivos clave

- `main.py` – arranque FastAPI
- `routes/` – API REST por entidad
- `models/` – estructuras Pydantic
- `Dockerfile`, `requirements.txt`, `.env.example`

---

Este microservicio es esencial para el cumplimiento documental y trazabilidad de calidad dentro de la PCD.