# 📡 Plataforma Centralizada de Datos – API Gateways

Este documento describe cada uno de los microservicios gateway creados para integrar distintos sistemas externos con la Plataforma Centralizada de Datos (PCD). Todos los gateways están diseñados como contenedores independientes, desplegables en Kubernetes, y exponen APIs REST para su integración con FYR, Facit u otros módulos del sistema.

---

## 🔌 GoodWe Gateway

**Ruta:** `/scripts/backend-files/gateways/goodwe/`  
**Puerto por defecto:** `8080`

### Funciones:
- Conexión con inversores solares GoodWe vía SEMS API
- Endpoints REST:
  - `GET /plants` → Listado de instalaciones registradas
  - `GET /status/{plant_id}` → Estado actual del inversor
- Autenticación integrada por email/contraseña

---

## 🟡 Sonoff Gateway

**Ruta:** `/scripts/backend-files/gateways/sonoff/`  
**Puerto por defecto:** `8081`

### Funciones:
- Detección de dispositivos Sonoff en red local (LAN)
- Control: encendido/apagado, consulta de estado
- API REST:
  - `GET /devices`
  - `POST /control/{id}/on`, `/off`
  - `GET /status/{id}`

---

## 🔵 Tuya Gateway

**Ruta:** `/scripts/backend-files/gateways/tuya/`  
**Puerto por defecto:** `8082`

### Funciones:
- Conexión con dispositivos Tuya vía Cloud API
- Autenticación por `client_id` y `client_secret`
- API REST:
  - `GET /devices`
  - `GET /status/{device_id}`
  - `POST /control/{device_id}/on` / `/off`

---

## 🟢 Schneider Electric Gateway

**Ruta:** `/scripts/backend-files/gateways/schneider/`  
**Puerto por defecto:** `8083`

### Funciones:
- Conexión con plataforma Resource Advisor de Schneider Electric
- OAuth 2.0 Client Credentials para autenticación
- API REST:
  - `GET /sites`
  - `GET /consumption/{site_id}`

---

## 🟣 SIGENA Gateway

**Ruta:** `/scripts/backend-files/gateways/sigena/`  
**Puerto por defecto:** `8084`

### Funciones:
- Microservicio base preparado para conectar con SIGENA (API aún no disponible)
- Simulación de dispositivos y estado

---

## 🧊 Daikin Gateway

**Ruta:** `/scripts/backend-files/gateways/daikin/`  
**Puerto por defecto:** `8085`

### Funciones:
- Control de unidades de climatización Daikin vía API local
- Comandos `get_control_info` y `set_control_info`
- API REST:
  - `GET /devices`
  - `GET /control/{ip}/status`
  - `POST /control/{ip}/command` (con payload)

---

Todos los microservicios incluyen:
- `Dockerfile` optimizado
- API REST con FastAPI
- Posibilidad de extender con autenticación, caching, integración con alertas

---

## 📦 Despliegue

Cada microservicio está listo para desplegar como:
- Contenedor Docker
- Servicio Kubernetes (`Deployment`, `Service`, `Ingress`)

La siguiente fase será generar los manifiestos y scripts de despliegue individuales.