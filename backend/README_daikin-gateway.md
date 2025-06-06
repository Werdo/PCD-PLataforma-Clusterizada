# ❄️ Daikin Gateway – Control de Equipos de Climatización

Este microservicio permite a la Plataforma Centralizada de Datos (PCD) conectarse y controlar unidades de aire acondicionado Daikin a través de su API local documentada (IM-DKNAPI).

---

## 📡 Funcionalidad

- Consulta del estado actual de los dispositivos (modo, temperatura, velocidad de ventilador)
- Control remoto (encender/apagar, cambiar modo, ajustar temperatura)
- Descubrimiento manual o por IP configurada

---

## 🔧 Endpoints REST

| Método | Ruta                        | Descripción                          |
|--------|-----------------------------|--------------------------------------|
| GET    | `/devices`                  | Lista de dispositivos simulados      |
| GET    | `/control/{ip}/status`      | Consulta estado vía `/get_control_info` |
| POST   | `/control/{ip}/command`     | Envía comandos vía `/set_control_info` con payload |

---

## 🧪 Ejemplo de Comando

```json
{
  "pow": "1",
  "mode": "3",
  "stemp": "22",
  "f_rate": "A"
}
```

Se envía a: `http://{ip}/skyfi/aircon/set_control_info`

---

## 🛠️ Requisitos

- Equipos Daikin en red local con interfaz SkyFi/WebControl habilitada
- Conexión IP directa al dispositivo

---

## ⚙️ Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8085"]
```

---

## 🔌 Integración en FYR

- Control visual de equipos desde panel de clima o instalaciones
- Monitorización de temperatura y modos activos
- Integración con alertas en caso de fallo o parámetro fuera de rango

---

Este microservicio hace posible la automatización de climatización en tiempo real desde la plataforma PCD, mejorando el confort y la eficiencia energética.