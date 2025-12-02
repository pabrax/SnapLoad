<div align="center">

# 🎵 SnapLoad

**Descargador de medios auto-hospedado para YouTube y Spotify**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](../LICENSE)
[![FastAPI](https://img.shields.io/badge/Backend-FastAPI-009688?logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Next.js](https://img.shields.io/badge/Frontend-Next.js_15-000000?logo=next.js&logoColor=white)](https://nextjs.org/)

*Plataforma moderna y de código abierto para descargar contenido multimedia con limpieza automática y seguimiento de progreso en tiempo real*

[🇬🇧 English](../README.md) | [🇪🇸 Español](#)

</div>

---

## 📋 Descripción General

SnapLoad es una aplicación full-stack auto-hospedada para descargar contenido de audio y video desde YouTube y Spotify. Consiste en dos componentes principales:

- **[snapLoad-API](../snapLoad-API/)** - Backend FastAPI con sistema de limpieza automática
- **[snapLoad-UI](../snapLoad-UI/)** - Frontend moderno en Next.js 15 con seguimiento de progreso en tiempo real

### Características Principales

✨ **Soporte Multi-Plataforma**: Descarga desde YouTube y Spotify
🎵 **Formatos de Audio**: MP3 con calidad personalizable (128k, 192k, 320k)
🎬 **Descargas de Video**: Formato WebM con calidad optimizada
📦 **Soporte de Playlists**: Descarga listas de reproducción completas con seguimiento de progreso
🧹 **Limpieza Automática**: Tiempo de retención configurable y limpieza programada
💾 **Optimización de Recursos**: Eliminación automática de archivos antiguos para ahorrar espacio
🔄 **Progreso en Tiempo Real**: Actualizaciones en vivo del estado de descarga mediante polling
🎨 **UI Moderna**: Interfaz hermosa y responsiva con Tailwind CSS
🐳 **Listo para Docker**: Configuración completa de Docker Compose para despliegue fácil

---

## 🚀 Inicio Rápido

SnapLoad consiste de **dos repositorios independientes**:
- **Backend**: [github.com/pabrax/SnapLoad-API](https://github.com/pabrax/SnapLoad-API)
- **Frontend**: [github.com/pabrax/SnapLoad-UI](https://github.com/pabrax/SnapLoad-UI)

### Requisitos Previos

- **Python 3.12+** (para backend)
- **Node.js 20+** (para frontend)
- **ffmpeg** (requerido para procesamiento de medios)
- **Docker & Docker Compose** (opcional, para despliegue en contenedores)

### Opción 1: Desarrollo Local

**Clonar ambos repositorios:**
```bash
# Backend
git clone https://github.com/pabrax/SnapLoad-API.git
cd SnapLoad-API
pip install uv  # o: curl -LsSf https://astral.sh/uv/install.sh | sh
uv sync
cp .env.example .env
uv run python main.py

# Frontend (en nueva terminal)
cd ..
git clone https://github.com/pabrax/SnapLoad-UI.git
cd SnapLoad-UI
npm install -g pnpm
pnpm install
cp .env.local.example .env.local
# Editar .env.local: NEXT_PUBLIC_API_URL=http://localhost:8000
pnpm dev
```

Accede a la aplicación en `http://localhost:3000`

### Opción 2: Docker (Despliegues Separados)

**Backend:**
```bash
cd SnapLoad-API
docker-compose up -d
# API disponible en http://localhost:8000
```

**Frontend:**
```bash
cd SnapLoad-UI
# Construir con URL del backend
docker build -t snapload-ui --build-arg NEXT_PUBLIC_API_URL=http://localhost:8000 .
docker run -d -p 3000:3000 snapload-ui
# UI disponible en http://localhost:3000
```

### Opción 3: Full Stack con Docker Compose (Pruebas Locales)

Clona ambos repos como hermanos, luego ejecuta desde el directorio UI:

```bash
carpeta-padre/
├── SnapLoad-API/
└── SnapLoad-UI/

# Desde el directorio SnapLoad-UI
docker-compose up -d
```

Esto ejecuta ambos servicios juntos para desarrollo/pruebas locales.

---

## 📁 Estructura del Proyecto

```
SnapLoad/
├── snapLoad-API/           # Backend FastAPI
│   ├── app/
│   │   ├── routes/        # Endpoints de la API
│   │   ├── services/      # Servicios de descarga (YouTube, Spotify)
│   │   ├── managers/      # Gestores de trabajos y limpieza
│   │   └── core/          # Configuración y excepciones
│   ├── downloads/         # Archivos multimedia descargados
│   ├── logs/              # Logs de descargas
│   ├── meta/              # Archivos JSON de metadatos
│   ├── tmp/               # Archivos temporales de procesamiento
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── pyproject.toml
│   └── README.md          # Documentación del backend
│
└── snapLoad-UI/           # Frontend Next.js
    ├── app/
    │   ├── page.tsx       # Página de descargas de audio
    │   ├── video/         # Página de descargas de video
    │   └── api/           # Rutas API proxy
    ├── src/
    │   ├── components/    # Componentes React
    │   ├── hooks/         # Custom React hooks
    │   ├── lib/           # Utilidades y helpers
    │   └── types/         # Definiciones TypeScript
    ├── Dockerfile
    ├── docker-compose.yml # Full stack (incluye backend)
    └── README.md          # Documentación del frontend
```

---

## 🔧 Configuración

### Entorno del Backend (.env)

```bash
# Configuración de Limpieza
RETENTION_HOURS=3              # Mantener archivos por 3 horas
CLEANUP_CRON="0 * * * *"       # Limpiar cada hora
ENABLE_ADMIN_ENDPOINTS=false   # Deshabilitar en producción

# Configuración del Servidor
PORT=8000
WORKERS=1
```

### Entorno del Frontend (.env.local)

```bash
# URL de la API Backend
NEXT_PUBLIC_API_URL=http://localhost:8000
```

Ver READMEs individuales para opciones detalladas de configuración:
- [Configuración del Backend](https://github.com/pabrax/SnapLoad-API#-configuration)
- [Configuración del Frontend](https://github.com/pabrax/SnapLoad-UI#-configuration)

---

## 📚 Documentación

### Backend (SnapLoad-API)
- [📖 Repositorio](https://github.com/pabrax/SnapLoad-API)
- [📖 Documentación Completa (EN)](https://github.com/pabrax/SnapLoad-API#readme)
- [🇪🇸 Documentación en Español](https://github.com/pabrax/SnapLoad-API/blob/main/docs/README.es.md)
- Endpoints API, sistema de limpieza, guías de despliegue

### Frontend (SnapLoad-UI)
- [📖 Repositorio](https://github.com/pabrax/SnapLoad-UI)
- [📖 Documentación Completa (EN)](https://github.com/pabrax/SnapLoad-UI#readme)
- [🇪🇸 Documentación en Español](https://github.com/pabrax/SnapLoad-UI/blob/main/docs/README.es.md)
- Estructura de componentes, hooks, flujo de desarrollo

---

## 🐳 Despliegue con Docker

### Servicios Individuales (Recomendado para Producción)

**Backend:**
```bash
git clone https://github.com/pabrax/SnapLoad-API.git
cd SnapLoad-API
docker-compose up -d
# API: http://localhost:8000
```

**Frontend:**
```bash
git clone https://github.com/pabrax/SnapLoad-UI.git
cd SnapLoad-UI
docker build -t snapload-ui --build-arg NEXT_PUBLIC_API_URL=https://tu-api.com .
docker run -d -p 3000:3000 snapload-ui
# UI: http://localhost:3000
```

### Full Stack (Desarrollo Local)

Clona ambos repos como hermanos y ejecuta desde el directorio UI:

```bash
docker-compose up -d
```

Esto iniciará:
- **Backend API** en el puerto 8000
- **Frontend UI** en el puerto 3000

### Servicios Individuales

**Solo Backend:**
```bash
cd snapLoad-API
docker-compose up -d
```

**Solo Frontend (requiere URL del backend):**
```bash
cd snapLoad-UI
docker build -t snapload-ui:latest .
docker run -d -p 3000:3000 -e NEXT_PUBLIC_API_URL=http://backend:8000 snapload-ui:latest
```

---

## 🛠️ Stack Tecnológico

### Backend
- **Framework**: FastAPI 0.115+
- **Gestor de Paquetes**: uv (instalador moderno de paquetes Python)
- **Herramientas de Descarga**: yt-dlp, spotdl
- **Procesamiento de Medios**: ffmpeg
- **Programador**: APScheduler 3.11+
- **Base de Datos**: SQLite (seguimiento de trabajos)

### Frontend
- **Framework**: Next.js 15.2+ (App Router)
- **Librería UI**: React 19
- **Lenguaje**: TypeScript 5+
- **Estilos**: Tailwind CSS 4.1+
- **Componentes**: shadcn/ui, Radix UI
- **Gestor de Paquetes**: pnpm

---

## 🧹 Sistema de Limpieza Automática

El backend incluye un sistema de limpieza inteligente que automáticamente elimina archivos antiguos para ahorrar espacio en disco:

- ⏰ **Ejecución Programada**: Horario cron configurable (por defecto: cada hora)
- 🕒 **Política de Retención**: Tiempo de retención configurable (por defecto: 3 horas)
- 📂 **Múltiples Objetivos**: Limpia descargas, logs, metadatos, archivos temporales y base de datos
- 📊 **Estadísticas**: Reportes detallados de limpieza con conteos de archivos y espacio liberado
- 🔒 **Seguro para Producción**: Endpoints admin deshabilitados por defecto

---

## 📝 Endpoints de la API

### Descarga
- `POST /download` - Encolar trabajo de descarga
- `GET /status/{job_id}` - Verificar estado de descarga
- `GET /files/{job_id}/download/{filename}` - Descargar archivo
- `POST /cancel/{job_id}` - Cancelar trabajo en ejecución

### Información
- `POST /info` - Obtener información de video/audio
- `GET /health` - Endpoint de verificación de salud

### Admin (Solo Desarrollo)
- `POST /admin/cleanup/trigger` - Limpieza manual
- `GET /admin/cleanup/config` - Ver configuración de limpieza
- `GET /admin/cleanup/stats` - Estadísticas de limpieza

Ver [Documentación de la API del Backend](../snapLoad-API/README.md#-api-reference) para detalles completos.

---

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! No dudes en enviar issues y pull requests.

### Configuración de Desarrollo

1. Haz fork del repositorio
2. Crea una rama de funcionalidad: `git checkout -b feature/caracteristica-increible`
3. Realiza tus cambios
4. Commit: `git commit -m 'Agregar característica increíble'`
5. Push: `git push origin feature/caracteristica-increible`
6. Abre un Pull Request

---

## ⚖️ Aviso Legal

**IMPORTANTE**: Este software se proporciona solo para uso educativo y personal.

- ✅ **Permitido**: Descargar contenido que posees o tienes permiso para descargar
- ✅ **Permitido**: Archivar contenido para uso personal, no comercial
- ❌ **Prohibido**: Descargar contenido con derechos de autor sin autorización
- ❌ **Prohibido**: Uso comercial o redistribución de contenido descargado
- ❌ **Prohibido**: Violar los Términos de Servicio de las plataformas

**Los usuarios son los únicos responsables** de asegurar que su uso cumple con:
- Leyes de derechos de autor en su jurisdicción
- Términos de Servicio de las plataformas (YouTube, Spotify, etc.)
- Regulaciones locales sobre descargas de medios

Los desarrolladores no asumen **ninguna responsabilidad** por el mal uso de este software.

---

## 📄 Licencia

Este proyecto está licenciado bajo la **Licencia MIT** - ver el archivo [LICENSE](../LICENSE) para más detalles.

---

## 🔗 Proyectos Relacionados

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - Descargador de YouTube
- [spotdl](https://github.com/spotDL/spotify-downloader) - Descargador de Spotify
- [FastAPI](https://fastapi.tiangolo.com/) - Framework web moderno de Python
- [Next.js](https://nextjs.org/) - Framework de React

---

## 📞 Soporte

- 🐛 [Reportar Problemas](https://github.com/pabrax/SnapLoad/issues)
- 💬 [Discusiones](https://github.com/pabrax/SnapLoad/discussions)
- 📧 Contacto: [Perfil de GitHub](https://github.com/pabrax)

---

<div align="center">

**Hecho con ❤️ por [pabrax](https://github.com/pabrax)**

⭐ ¡Dale una estrella a este proyecto si te resulta útil!

</div>
