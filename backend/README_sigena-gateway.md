# 🟨 SIGENA Gateway – Conector base para sistemas SIGENA

Este microservicio está diseñado como punto de integración con los sistemas SIGENA (https://www.sigena.es/proyectos), usados habitualmente en entornos industriales, energéticos o de control técnico.

---

## ❓ Estado actual

- La API pública de SIGENA aún no ha sido publicada o facilitada
- Este gateway contiene una estructura básica y endpoints simulados
- Listo para recibir lógica real cuando se disponga de documentación oficial

---

## 📦 API REST Simulada

| Método | Ruta                  | Descripción                         |
|--------|-----------------------|-------------------------------------|
| GET    | `/devices`            | Lista de dispositivos simulados     |
| GET    | `/devices/{id}/status`| Estado simulado de un dispositivo   |

---

## 🧪 Ejemplo de respuesta

```json
[
  {
    "id": "device-001",
    "name": "SIGENA sensor A"
  }
]
```

---

## 🛠️ Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8084"]
```

---

## 📌 Preparado para

- Adaptarse al formato y protocolos reales que SIGENA publique (REST, MQTT, SOAP…)
- Conectarse con FYR y Facit una vez implementado
- Simulación de flujo completo para desarrollo previo

---

Este microservicio actúa como "stub" o base funcional para una futura integración completa con los sistemas SIGENA.