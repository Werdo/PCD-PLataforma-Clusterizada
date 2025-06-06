# 🟦 Tuya Gateway – Integración con Dispositivos Tuya Cloud

Este microservicio permite conectar la Plataforma Centralizada de Datos (PCD) con dispositivos inteligentes registrados en la plataforma Tuya Smart a través de su API en la nube.

---

## 🌐 Requisitos

- Tener una cuenta de desarrollador en [Tuya IoT Platform](https://iot.tuya.com)
- Obtener un `Client ID` y `Client Secret` desde el proyecto creado
- Asociar dispositivos a tu proyecto Tuya

---

## 📦 Endpoints REST

| Método | Ruta                    | Descripción                          |
|--------|-------------------------|--------------------------------------|
| GET    | `/devices`              | Lista de dispositivos Tuya conectados |
| GET    | `/status/{device_id}`   | Estado actual del dispositivo        |
| POST   | `/control/{device_id}/on`  | Enciende dispositivo específico      |
| POST   | `/control/{device_id}/off` | Apaga dispositivo específico         |

---

## 🔧 Configuración

### Variables de entorno `.env`

```env
TUYA_CLIENT_ID=xxxxxxxxxxxxxxxxxxxx
TUYA_CLIENT_SECRET=yyyyyyyyyyyyyyyy
```

Estas claves se obtienen desde el panel de desarrollador de Tuya IoT Cloud.

---

## ⚙️ Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8082"]
```

---

## 🔁 Flujo de autenticación

1. El cliente obtiene un `access_token` mediante `client_id` y `client_secret`
2. El token se usa en los headers de cada solicitud API a Tuya
3. Si el token expira, se renueva automáticamente

---

## 📌 Aplicaciones en FYR

- Control de interruptores, sensores, bombillas, enchufes inteligentes
- Lectura de temperatura, humedad, estado de dispositivos
- Uso como puente hacia ecosistemas Zigbee/Z-Wave vía Tuya Gateway

---

Este microservicio permite controlar un gran número de dispositivos domésticos e industriales inteligentes sin necesidad de red local, directamente desde la nube.