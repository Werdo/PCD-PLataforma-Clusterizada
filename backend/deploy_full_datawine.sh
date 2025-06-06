#!/bin/bash
echo "📦 Descomprimiendo microservicio..."
unzip -o ../../../../backend/datawine-gateway.zip -d ./datawine-app

cd ./datawine-app
#!/bin/bash
echo "🚀 Construyendo imagen Docker para datawine-gateway..."
docker build -t ppelaez/datawine-gateway:latest .

echo "📤 Subiendo imagen a Docker Hub..."
docker push ppelaez/datawine-gateway:latest

echo "🧱 Aplicando deployment y service..."
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

echo "🌐 Aplicando Ingress..."
kubectl apply -f ingress.yaml

echo "✅ Despliegue completo de datawine-gateway realizado."