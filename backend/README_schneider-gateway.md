# 🟩 Schneider Gateway – Conexión con Resource Advisor (SE)

Este microservicio permite conectar la Plataforma Centralizada de Datos (PCD) con la plataforma de sostenibilidad y consumo energético de Schneider Electric: Resource Advisor.

---

## 🔐 Requisitos

- Acceso autorizado a la API de Schneider Electric
- Credenciales `client_id` y `client_secret` para autenticación OAuth 2.0

---

## 📦 Endpoints REST

| Método | Ruta               | Descripción                          |
|--------|--------------------|--------------------------------------|
| GET    | `/sites`           | Obtiene todos los sitios registrados |
| GET    | `/consumption/{id}`| Datos de consumo energético por sitio |

---

## 🔧 Configuración

### Variables de entorno `.env`

```env
SCHNEIDER_CLIENT_ID=tu_client_id
SCHNEIDER_CLIENT_SECRET=tu_client_secret
```

---

## ⚙️ Autenticación

- Utiliza el protocolo OAuth 2.0 con client credentials
- Cada solicitud obtiene un `access_token` válido por un período limitado
- Token se renueva automáticamente en cada llamada si es necesario

---

## 🛠️ Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8083"]
```

---

## 📊 Aplicaciones en FYR / Facit

- Consulta del estado energético por planta o edificio
- Monitorización de consumo mensual, diario, instantáneo
- Comparación entre sitios o áreas productivas

---

## 🧩 Futuras integraciones

- Visualización gráfica en dashboards internos
- Alertas por exceso de consumo
- Exportación de informes automáticos

---

Este gateway permite aprovechar los datos ya capturados por Schneider Electric y convertirlos en información útil dentro de la PCD.