# 🍷 DataWine Gateway – Conector con API Pública de DataWine

Este microservicio conecta la Plataforma Centralizada de Datos (PCD) con la API pública de DataWine. Permite acceder a información de usuarios, depósitos y barricas en tiempo real, mediante una capa REST local integrada con FYR y otros servicios.

---

## 📦 Endpoints REST

### Usuarios

| Método | Ruta               | Descripción                        |
|--------|--------------------|------------------------------------|
| GET    | `/usuarios/`       | Lista todos los usuarios           |
| GET    | `/usuarios/{id}`   | Datos de un usuario por ID         |

### Depósitos

| Método | Ruta                | Descripción                       |
|--------|---------------------|-----------------------------------|
| GET    | `/depositos/`       | Lista todos los depósitos         |
| GET    | `/depositos/{id}`   | Información detallada de un depósito |

### Barricas

| Método | Ruta                | Descripción                       |
|--------|---------------------|-----------------------------------|
| GET    | `/barricas/`        | Lista todas las barricas registradas |
| GET    | `/barricas/{id}`    | Detalles de una barrica específica  |

---

## 🔧 Configuración

### Variables de entorno

```env
DATAWINE_API=https://api.datawine.io
```

---

## 🛠️ Despliegue

### Dockerfile

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8086"]
```

### Kubernetes

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
```

---

## 📌 Aplicaciones en FYR / Facit

- Visualización de inventario enológicos
- Consultas rápidas a DataWine desde procesos de control
- Posibilidad de combinar con trazabilidad y gestión documental

---

Este gateway permite una integración fluida con DataWine sin necesidad de exponer directamente los servicios externos al frontend o a los usuarios.