# 💡 Sonoff Gateway – Control LAN de Dispositivos Sonoff

Este microservicio permite a la Plataforma Centralizada de Datos (PCD) detectar, controlar y gestionar dispositivos Sonoff a través de la red local (LAN), sin depender de la nube eWeLink.

---

## 🧩 Basado en

- Proyecto [SonoffLAN (AlexxIT)](https://github.com/AlexxIT/SonoffLAN)
- Comunicación directa con dispositivos por broadcast + IP

---

## 📦 API REST

| Método | Ruta                 | Descripción                     |
|--------|----------------------|---------------------------------|
| GET    | `/devices`           | Lista de dispositivos detectados |
| POST   | `/control/{id}/on`   | Enciende dispositivo por ID     |
| POST   | `/control/{id}/off`  | Apaga dispositivo               |
| GET    | `/status/{id}`       | Consulta el estado actual       |

---

## 📡 Funcionalidad

- Detecta automáticamente dispositivos en LAN
- Almacena y nombra los dispositivos encontrados
- Permite control individual vía HTTP

---

## 🔧 Requisitos

- Los dispositivos deben estar en modo LAN activado
- Estar en la misma subred local que el gateway

---

## ⚙️ Configuración

```env
# No se requiere configuración por defecto
```

### Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8081"]
```

---

## 🌐 Integración FYR / Facit

- Control visual (encendido/apagado) desde interfaz FYR
- Monitorización del estado de sensores Sonoff
- Posibilidad de incluir en dashboards de clima o iluminación

---

Este gateway es ideal para domótica ligera, control de relés, luces, enchufes o sensores de temperatura/humedad dentro de la plataforma.