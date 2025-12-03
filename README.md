<div align="center">
  <img src="docs/SnapLoad_preview.png" alt="SnapLoad Preview" width="800"/>
  
  # SnapLoad
  
  ### Descarga música y videos de YouTube/Spotify de forma sencilla
  
  [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
  [![Docker](https://img.shields.io/badge/Docker-ready-blue.svg)](https://www.docker.com/)
  [![Python](https://img.shields.io/badge/Python-3.12-green.svg)](https://www.python.org/)
  [![Next.js](https://img.shields.io/badge/Next.js-15-black.svg)](https://nextjs.org/)
  
  [English](./docs/README.en.md) | **Español**
</div>

---

## 🚀 Instalación Rápida (Recomendada)

**Un solo comando para instalar y ejecutar SnapLoad:**

```bash
curl -fsSL https://raw.githubusercontent.com/pabrax/SnapLoad/main/install.sh | bash
```

O manualmente:

```bash
git clone --recursive https://github.com/pabrax/SnapLoad.git
cd SnapLoad
docker-compose up -d
```

**Accede a:**
- 🎨 Frontend: http://localhost:9013
- ⚙️ Backend API: http://localhost:9020
- 📚 Documentación API: http://localhost:9020/docs

---

## 📦 ¿Qué es SnapLoad?

SnapLoad es una aplicación full-stack que permite descargar música y videos de YouTube y Spotify de manera sencilla y rápida. Ideal para crear tu biblioteca de medios local.

### ✨ Características

- 🎵 **Audio de YouTube y Spotify** - Descarga canciones en alta calidad
- 🎬 **Videos de YouTube** - Múltiples formatos y resoluciones
- 📋 **Soporte de playlists** - Descarga playlists completas
- 🔄 **Sistema de caché inteligente** - Evita descargas duplicadas
- 🧹 **Limpieza automática** - Gestión automática del espacio en disco
- 🐳 **Docker ready** - Despliegue simplificado
- 🌐 **API RESTful** - Integración fácil con otros servicios

---

## 🏗️ Estructura del Proyecto

Este es un monorepo que contiene dos proyectos independientes como Git submodules:

```
SnapLoad/
├── snapLoad-API/          # Backend (FastAPI + Python)
│   ├── app/
│   ├── Dockerfile
│   └── README.md
├── snapLoad-UI/           # Frontend (Next.js + React)
│   ├── src/
│   ├── Dockerfile
│   └── README.md
├── docker-compose.yml     # Orquestación full-stack
├── install.sh            # Script de instalación automática
└── README.md             # Este archivo
```

### 📁 Repositorios Individuales

Cada componente tiene su propio repositorio en GitHub:

- **Backend**: [SnapLoad-API](https://github.com/pabrax/SnapLoad-API)
- **Frontend**: [SnapLoad-UI](https://github.com/pabrax/SnapLoad-UI)

Puedes clonar y trabajar con cada uno por separado si lo prefieres.

---

## 🛠️ Stack Tecnológico

### Backend
- **FastAPI** - Framework web moderno y rápido
- **yt-dlp** - Descarga de YouTube
- **spotdl** - Descarga de Spotify
- **SQLite** - Base de datos embebida
- **APScheduler** - Limpieza automática programada

### Frontend
- **Next.js 15** - Framework React con App Router
- **TypeScript** - Tipado estático
- **Tailwind CSS** - Estilos modernos
- **Shadcn/ui** - Componentes UI elegantes

---

## 📖 Instalación Detallada

### Opción 1: Docker (Recomendada)

**Requisitos:**
- Docker 20.10+
- Docker Compose 2.0+
- Git

**Pasos:**

1. **Clonar el repositorio con submodules:**
```bash
git clone --recursive https://github.com/pabrax/SnapLoad.git
cd SnapLoad
```

2. **Configurar variables de entorno (opcional):**
```bash
# Backend
cp snapLoad-API/.env.example snapLoad-API/.env
# Editar snapLoad-API/.env si necesitas personalizar

# Frontend
cp snapLoad-UI/.env.local.example snapLoad-UI/.env.local
# Editar snapLoad-UI/.env.local si necesitas personalizar
```

3. **Iniciar los servicios:**
```bash
docker-compose up -d
```

4. **Verificar que todo funciona:**
```bash
docker-compose ps
docker-compose logs -f
```

**Detener los servicios:**
```bash
docker-compose down
```

---

### Opción 2: Desarrollo Local (sin Docker)

**Requisitos:**
- Python 3.12+
- Node.js 20+
- pnpm
- uv (gestor de paquetes Python)
- FFmpeg

**Backend:**
```bash
cd snapLoad-API

# Instalar dependencias
uv sync

# Copiar .env
cp .env.example .env

# Ejecutar
uv run uvicorn app.api:app --reload --host 0.0.0.0 --port 8000
```

**Frontend:**
```bash
cd snapLoad-UI

# Instalar dependencias
pnpm install

# Copiar .env
cp .env.local.example .env.local

# Ejecutar
pnpm dev
```

---

## 🔧 Configuración

### Backend (`.env`)

```bash
# Configuración de limpieza
RETENTION_HOURS=3                    # Tiempo de vida de archivos
TEMP_RETENTION_HOURS=1               # Tiempo de vida de temporales
CLEANUP_CRON="0 * * * *"            # Cada hora
TEMP_CLEANUP_CRON="0 */30 * * *"    # Cada 30 minutos

# Endpoints admin (solo desarrollo)
ENABLE_ADMIN_ENDPOINTS=false

# Logs
CLEANUP_LOG_LEVEL=INFO
```

### Frontend (`.env.local`)

```bash
NEXT_PUBLIC_API_URL=http://localhost:8000
```

---

## 📚 Documentación de la API

Una vez ejecutando el backend, accede a:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Endpoints Principales

```bash
# Descargar audio
POST /download/audio
{
  "url": "https://youtube.com/watch?v=...",
  "quality": "192k"
}

# Descargar video
POST /download/video
{
  "url": "https://youtube.com/watch?v=...",
  "quality": "1080p",
  "format": "mp4"
}

# Obtener archivo descargado
GET /files/{job_id}/{filename}

# Estado del servidor
GET /health
```

---

## 🧹 Sistema de Limpieza Automática

SnapLoad incluye un sistema inteligente de limpieza que:

- 🗑️ **Elimina archivos antiguos** automáticamente según configuración
- 📊 **Gestiona el espacio en disco** para evitar saturación
- 🔄 **Limpia temporales** cada 30 minutos
- 📝 **Registra todas las operaciones** en logs detallados

**Configuración por defecto:**
- Archivos descargados: **3 horas** de retención
- Archivos temporales: **1 hora** de retención
- Limpieza automática: **cada hora**

---

## 🔄 Actualizar SnapLoad

Para actualizar a la última versión:

```bash
cd SnapLoad

# Actualizar el repo principal
git pull

# Actualizar los submodules
git submodule update --remote --merge

# Reconstruir los contenedores
docker-compose up -d --build
```

---

## 🐛 Troubleshooting

### Los servicios no inician

```bash
# Ver logs
docker-compose logs -f

# Reiniciar servicios
docker-compose restart

# Reconstruir desde cero
docker-compose down
docker-compose up -d --build
```

### Backend no se conecta

1. Verifica que el backend esté corriendo: `docker-compose ps`
2. Verifica los logs: `docker-compose logs backend`
3. Verifica que el puerto 8000 esté libre: `lsof -i :8000`

### Frontend no muestra datos

1. Verifica la variable `NEXT_PUBLIC_API_URL` en `.env.local`
2. Verifica que el backend responda: `curl http://localhost:8000/health`
3. Revisa la consola del navegador para errores

---

## 🤝 Contribuir

Las contribuciones son bienvenidas en cualquiera de los repositorios:

1. Fork el proyecto que quieres mejorar ([API](https://github.com/pabrax/SnapLoad-API) o [UI](https://github.com/pabrax/SnapLoad-UI))
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la licencia GPL-3.0. Ver archivos `LICENSE` en cada subproyecto para más detalles.

- [Licencia Backend](snapLoad-API/LICENSE)
- [Licencia Frontend](snapLoad-UI/LICENSE)

### Licencias de Terceros

Este proyecto utiliza software de terceros que está bajo sus propias licencias:

- **spotdl** (MIT License) - Herramienta para descargar audio de Spotify
- **yt-dlp** (Unlicense) - Herramienta para descargar videos de YouTube

Para más detalles sobre las licencias de las dependencias utilizadas, consulta:
- [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) - Licencias de terceros del proyecto principal
- [snapLoad-API/THIRD_PARTY_LICENSES.md](snapLoad-API/THIRD_PARTY_LICENSES.md) - Licencias de terceros del backend

---

## 👤 Autor

**Pablo Espinosa** - [@pabrax](https://github.com/pabrax)

---

## ⚠️ Legal Notice

Esta herramienta es solo para uso personal y educativo. Respeta los términos de servicio de YouTube y Spotify. No distribuyas contenido con copyright sin permiso.

---

<div align="center">
  Hecho con ❤️ por la comunidad open source
</div>
