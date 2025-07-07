# 🌍 Turistic Blog

Una aplicación móvil de blog turístico desarrollada en Flutter que permite a los usuarios compartir sus experiencias de viaje, descubrir nuevos destinos y conectar con otros viajeros.

## 📱 Características

- **📝 Creación de Posts**: Comparte tus experiencias de viaje con texto e imágenes
- **📍 Localización**: Cada post incluye información de ubicación del destino
- **🔐 Autenticación Segura**: Sistema de login y registro con Supabase
- **👥 Sistema de Roles**: Diferentes permisos para usuarios y administradores
- **🖼️ Galería de Imágenes**: Sube múltiples imágenes por post
- **💬 Sistema de Reseñas**: Los usuarios pueden dejar comentarios y valoraciones
- **📱 Interfaz Intuitiva**: Diseño moderno y fácil de usar

## 🛠️ Tecnologías Utilizadas

- **Flutter** - Framework de desarrollo móvil multiplataforma
- **Dart** - Lenguaje de programación
- **Supabase** - Backend como servicio (BaaS)
- **Cached Network Image** - Optimización de carga de imágenes
- **Image Picker** - Selección de imágenes desde cámara/galería
- **Permission Handler** - Gestión de permisos del dispositivo
- **Material Design 3** - Sistema de diseño de Google

## 📋 Requisitos Previos

- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android o iOS para pruebas

## 🚀 Instalación y Configuración

1. **Clona el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd turistic_blog
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Configura Supabase**
   - Crea un proyecto en [Supabase](https://supabase.com)
   - Actualiza las credenciales en `lib/main.dart`:
   ```dart
   await Supabase.initialize(
     url: 'tu_supabase_url',
     anonKey: 'tu_supabase_anon_key',
   );
   ```

4. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

## 📖 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── blog_page.dart           # Página principal del blog
├── login_page.dart          # Página de autenticación
├── models/                  # Modelos de datos
│   ├── blog_post.dart      # Modelo de post del blog
│   └── user_role.dart      # Modelo de roles de usuario
├── pages/                   # Páginas de la aplicación
│   ├── create_post_page.dart # Página para crear posts
│   └── post_detail_page.dart # Página de detalle del post
└── services/               # Servicios de la aplicación
    ├── auth_service.dart   # Servicio de autenticación
    └── blog_service.dart   # Servicio del blog
```

## 🖼️ Capturas de Pantalla

<!-- Aquí puedes agregar las capturas de pantalla de la aplicación -->
*[Espacio reservado para capturas de pantalla de la aplicación]*

### Pantalla Principal
![Pantalla Principal](screenshots/home_screen.png)

### Crear Post
![Crear Post](screenshots/create_post.png)

### Detalle del Post
![Detalle del Post](screenshots/post_detail.png)

### Login/Registro
![Login](screenshots/login_screen.png)

## 📦 Descarga la Aplicación

### APK para Android
Puedes descargar la última versión de la aplicación desde el siguiente enlace:

**[📱 Descargar APK](https://mega.nz/file/jBAwXKBR#gjWVdiSGnxUhpExHkJ_Akzl4jqwydAjXQDSy4L_fiYE)**

*Versión: 1.0.0*
*Tamaño: ~25 MB*
*Compatibilidad: Android 5.0 (API 21) o superior*

## 🔧 Desarrollo

### Comandos Útiles

```bash
# Ejecutar en modo debug
flutter run

# Compilar para release
flutter build apk --release

# Ejecutar tests
flutter test

# Analizar código
flutter analyze

# Formatear código
dart format .
```

### Configuración de Iconos y Splash Screen

El proyecto incluye configuración automática para:
- **Icono de la aplicación**: `assets/iconoApp.png`
- **Splash screen**: Configurado con tema vino (#722F37)
- **Iconos adaptativos**: Para Android con fondo personalizado

## Autor
 - **Mathías Terán**

