#!/bin/bash

set -e

echo "==================================="
echo "  SnapLoad - Instalación Full Stack"
echo "==================================="
echo ""

# Verificar dependencias
command -v git >/dev/null 2>&1 || { echo "ERROR: Git no está instalado. Instálalo primero."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "ERROR: Docker no está instalado. Instálalo primero."; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo "ERROR: Docker Compose no está instalado. Instálalo primero."; exit 1; }

echo "[1/5] Verificando dependencias... OK"
echo ""

# Clonar el monorepo con submodules
echo "[2/5] Clonando repositorio..."
git clone --recursive https://github.com/pabrax/SnapLoad.git
cd SnapLoad

echo ""
echo "[3/5] Configurando variables de entorno..."

# Copiar .env de ejemplo para backend
if [ ! -f snapLoad-API/.env ]; then
    cp snapLoad-API/.env.example snapLoad-API/.env
    echo "      Backend: .env creado"
fi

# Copiar .env de ejemplo para frontend
if [ ! -f snapLoad-UI/.env.local ]; then
    cp snapLoad-UI/.env.local.example snapLoad-UI/.env.local
    echo "      Frontend: .env.local creado"
fi

echo ""
echo "[4/5] Construyendo contenedores Docker..."
docker-compose up -d --build

echo ""
echo "[5/5] Verificando servicios..."
sleep 10

# Verificar que los servicios estén corriendo
if docker-compose ps | grep -q "Up"; then
    echo ""
    echo "==================================="
    echo "  Instalación completada"
    echo "==================================="
    echo ""
    echo "Acceso a la aplicación:"
    echo "  - Frontend:  http://localhost:3000"
    echo "  - Backend:   http://localhost:8000"
    echo "  - API Docs:  http://localhost:8000/docs"
    echo ""
    echo "Comandos disponibles:"
    echo "  docker-compose logs -f     Ver logs en tiempo real"
    echo "  docker-compose down        Detener servicios"
    echo "  docker-compose restart     Reiniciar servicios"
    echo ""
else
    echo ""
    echo "ERROR: Los servicios no iniciaron correctamente"
    echo "Ejecuta 'docker-compose logs' para más información"
    exit 1
fi
