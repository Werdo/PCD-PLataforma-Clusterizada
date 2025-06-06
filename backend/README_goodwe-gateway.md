# 🔆 GoodWe Gateway – Integración con Inversores Solares

Este microservicio permite conectar la Plataforma Centralizada de Datos (PCD) con los inversores solares GoodWe a través de su plataforma SEMS (SEMS Portal).

---

## 🔐 Requisitos

- Credenciales del usuario (email + password) de la cuenta SEMS
- Acceso a internet para conexión con la nube GoodWe

---

## 📦 Endpoints REST

| Método | Ruta                | Descripción                             |
|--------|---------------------|-----------------------------------------|
| GET    | `/plants`           | Obtiene listado de plantas asociadas al usuario |
| GET    | `/status/{plant_id}`| Devuelve el estado y datos en tiempo real del inversor |

---

## 🧠 Ejemplo de respuesta

```json
[
  {
    "plant_id": "AB12345",
    "name": "Instalación Norte",
    "power": 4420.5,
    "status": "online"
  }
]
```

---

## 🛠️ Configuración

### Variables de entorno (.env)

```env
GOODWE_EMAIL=tu@correo.com
GOODWE_PASSWORD=contraseña123
```

### Dockerfile (resumen)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
```

---

## 🤝 Integraciones posibles

- Mostrar rendimiento de la instalación solar en FYR
- Notificar cortes, caídas o rendimiento bajo vía alerts-engine
- Almacenamiento de métricas para visualización en dashboards

---

Este gateway es clave para conectar el sistema energético con la plataforma de gestión y control de datos de producción renovable.