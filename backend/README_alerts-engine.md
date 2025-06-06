# 🚨 Alerts Engine – Sistema de Gestión de Alertas PCD

Este microservicio forma parte de la Plataforma Centralizada de Datos (PCD) y permite gestionar alertas generadas por condiciones de valores, eventos o ubicaciones (geofencing). Se integra con FYR, Facit y otros servicios internos como `document-control`.

---

## 🎯 Funcionalidades

- Registro y visualización de alertas activas o históricas
- Reglas configurables por tipo (`valor`, `geofence`)
- Zonas geográficas y activadores por entrada/salida de zona
- Generación automática desde otros servicios (vía API)
- Notificación en tiempo real por WebSocket

---

## 📦 Estructura REST (FastAPI)

### 📍 Endpoints de Alertas

| Método | Ruta         | Descripción                       |
|--------|--------------|-----------------------------------|
| GET    | `/alerts`    | Listar alertas activas o recientes |
| POST   | `/alerts`    | Crear nueva alerta manual o externa |

### ⚙️ Reglas

| Método | Ruta       | Descripción                            |
|--------|------------|----------------------------------------|
| GET    | `/rules`   | Obtener todas las reglas configuradas  |
| POST   | `/rules`   | Añadir nueva regla                     |

```json
{
  "id": "rule001",
  "type": "value",
  "threshold": 50
}
```

### 🌐 Geofencing

| Método | Ruta         | Descripción                      |
|--------|--------------|----------------------------------|
| GET    | `/geofence`  | Listar zonas geográficas definidas |
| POST   | `/geofence`  | Crear nueva zona circular        |

```json
{
  "id": "zona01",
  "name": "Depósito Norte",
  "lat": 41.4036,
  "lon": 2.1744,
  "radius": 150.0
}
```

---

## 📡 WebSocket

El servicio incluye un endpoint WebSocket:
```
/ws/{cliente}
```
Al recibir una nueva alerta, se envía automáticamente a todos los clientes conectados.

```json
{
  "type": "document",
  "message": "Certificado GFSI inválido en proveedor V4"
}
```

---

## 🧪 Lógica de evaluación

- `value`: Se compara el valor recibido contra el umbral
- `geofence`: Se calcula si una ubicación está dentro o fuera de la zona
- Se puede extender para incluir combinaciones (ej: inactividad, condiciones múltiples)

---

## 🛠️ Despliegue

### Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8090"]
```

### Variables de entorno

- Puerto: `8090`

### Kubernetes

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
```

---

## 🤝 Integraciones

- `document-control`: genera alertas automáticas al subir documentos inválidos
- `fyr`: muestra las alertas en tiempo real a usuarios
- `facit`: vista administrativa de todas las alertas de la plataforma

---

Este microservicio centraliza toda la lógica de alertas, y permite a cualquier componente de la plataforma emitir o consumir eventos críticos.