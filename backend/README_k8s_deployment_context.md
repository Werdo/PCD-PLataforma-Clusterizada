# ☸️ Despliegue de Gateways en Kubernetes – Contexto de Carpeta

Este documento resume cómo se encuentran organizados los archivos para el despliegue de los gateways y servicios auxiliares dentro de la Plataforma Centralizada de Datos (PCD) y cómo deben ser utilizados desde los scripts de despliegue de Kubernetes.

---

## 📁 Carpeta base

Los archivos se ubican en:

```
/home/ppelaez/scripts/backend/
```

---

## 📦 Archivos ZIP incluidos

| Archivo ZIP                      | Contiene                                                                 |
|----------------------------------|--------------------------------------------------------------------------|
| `gateway-scripts.zip`           | Carpeta `gateways/` con manifiestos `deployment.yaml`, `service.yaml` y scripts individuales por gateway |
| `gateway-scripts-updated.zip`   | Versión con scripts completos `deploy_full_{gateway}.sh` y `ingress.yaml` |
| `document-control.zip`          | Microservicio completo `document-control` con API REST + validación     |
| `alerts-engine.zip`             | Servicio de alertas centralizado con reglas y geofence                  |
| `doc-validator.zip`             | Servicio de validación OCR para documentos                              |
| `goodwe-gateway.zip`            | Conector para inversores solares GoodWe                                 |
| `sonoff-gateway.zip`            | Gateway LAN para dispositivos Sonoff                                     |
| `tuya-gateway.zip`              | Gateway Tuya Cloud                                                       |
| `schneider-gateway.zip`         | Gateway Schneider Resource Advisor                                       |
| `sigena-gateway.zip`            | Conector base SIGENA (pendiente de integración real)                     |
| `daikin-gateway.zip`            | Controlador de equipos de aire Daikin                                    |

---

## 🗂 Estructura por ZIP

Ejemplo interno de un ZIP de gateway:

```
gateways/{gateway}/
  ├─ deployment.yaml
  ├─ service.yaml
  ├─ ingress.yaml
  ├─ deploy_full_{gateway}.sh
```

---

## 🧰 Uso recomendado

1. **Extraer todos los ZIP** en `/home/ppelaez/scripts/backend/`
2. Cada subcarpeta de `gateways/{nombre}` quedará lista con su script de despliegue
3. Usar el script maestro:

```
/home/ppelaez/scripts/gateways/deploy_gateway_menu.sh
```

Este mostrará un menú para desplegar cualquier gateway por separado.

---

## ✅ Recomendación final

- Asegurarse de que todos los contenedores estén **construidos y subidos a Docker Hub**
- Configurar correctamente el dominio en los manifiestos de Ingress (`pcd.plataforma.local`)
- Aplicar los manifiestos con `kubectl apply -f` o desde los scripts generados

Este contexto permite a cualquier integrante del equipo desplegar, reiniciar o actualizar los gateways y servicios auxiliares sin perder consistencia.