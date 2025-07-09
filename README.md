# 🌍 Turistic Blog

Una aplicación móvil de blog turístico desarrollada en Flutter que permite a los usuarios compartir sus experiencias de viaje, descubrir nuevos destinos y conectar con otros viajeros.

## ✨ Últimas Mejoras (Enero 2025)

### � **Mejoras en la Interfaz de Login/Registro**
- **Separación clara** entre Login y Registro con pestañas
- **Validación en tiempo real** de campos
- **Mensajes de error descriptivos** y contextuales
- **Flujo de usuario mejorado** con instrucciones claras
- **Indicadores de carga** para mejor feedback visual
- **Página de ayuda integrada** con guías paso a paso

### 🎨 **Mejoras de UI/UX**
- **Diseño con pestañas** para mejor navegación
- **Colores y estilos consistentes** usando constantes
- **Widgets reutilizables** para mejor mantenimiento
- **Animaciones y transiciones** suaves
- **Botones de ayuda** accesibles
- **Feedback visual** para validaciones

### 🔐 **Mejoras de Seguridad y Funcionalidad**
- **Validación robusta** de email y contraseña
- **Confirmación de contraseña** obligatoria
- **Manejo de errores** mejorado
- **Estados de carga** apropiados
- **Limpieza de campos** después de registro exitoso

## �📱 Características

- **📝 Creación de Posts**: Comparte tus experiencias de viaje con texto e imágenes
- **📍 Localización**: Cada post incluye información de ubicación del destino
- **🔐 Autenticación Mejorada**: Sistema de login y registro con interfaz intuitiva
- **👥 Sistema de Roles**: Diferentes permisos para lectores y escritores
- **🖼️ Galería de Imágenes**: Sube múltiples imágenes por post
- **💬 Sistema de Reseñas**: Los usuarios pueden dejar comentarios y valoraciones
- **📱 Interfaz Intuitiva**: Diseño moderno con Material Design 3
- **❓ Sistema de Ayuda**: Guías integradas para nuevos usuarios

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
├── login_page.dart          # Página de autenticación (MEJORADA)
├── constants/               # Constantes de la aplicación
│   └── app_constants.dart   # Colores, strings, dimensiones
├── widgets/                 # Widgets reutilizables
│   └── custom_widgets.dart  # Campos de texto, botones, cards
├── models/                  # Modelos de datos
│   ├── blog_post.dart      # Modelo de post del blog
│   └── user_role.dart      # Modelo de roles de usuario
├── pages/                   # Páginas de la aplicación
│   ├── create_post_page.dart # Página para crear posts
│   ├── post_detail_page.dart # Página de detalle del post
│   └── help_page.dart       # Página de ayuda (NUEVA)
└── services/               # Servicios de la aplicación
    ├── auth_service.dart   # Servicio de autenticación
    └── blog_service.dart   # Servicio del blog
```

## 👥 Guía de Usuario

### � **Cómo Iniciar Sesión**
1. Abre la aplicación
2. Ve a la pestaña "Iniciar Sesión"
3. Ingresa tu email y contraseña
4. Presiona "Iniciar Sesión"

### 📝 **Cómo Crear una Cuenta**
1. Abre la aplicación
2. Ve a la pestaña "Registrarse"
3. Completa todos los campos:
   - Email válido
   - Contraseña (mínimo 6 caracteres)
   - Confirmar contraseña
4. Selecciona tu tipo de cuenta:
   - **Lector**: Solo leer artículos
   - **Escritor**: Crear y publicar artículos
5. Presiona "Crear Cuenta"
6. **Importante**: Revisa tu email para confirmar tu cuenta

### 🆘 **Si Necesitas Ayuda**
- Toca el botón "?" en la esquina superior derecha
- O toca "¿Necesitas ayuda?" en la pestaña de login
- Accede a la guía completa con instrucciones detalladas

## 🖼️ Capturas de Pantalla

### Login/Registro Mejorado

![login](https://github.com/user-attachments/assets/c50acb48-5cc1-400e-99f2-b4a735fc43e5)

![registrarse](https://github.com/user-attachments/assets/34f93aaa-410a-43a8-8d7d-e62856f01141)

### Página de Ayuda

![ayuda](https://github.com/user-attachments/assets/7bc70622-2270-404c-b8f8-4798e9148f3f)

### Pantalla Principal
![pantallaPrincipal](https://github.com/user-attachments/assets/6e519619-3319-4972-8026-517fe7ce303d)

### Crear Post
![CrearPost](https://github.com/user-attachments/assets/92adb0f0-65b7-4851-af4d-008c47756869)

### Detalle del Post
![DetallesPost](https://github.com/user-attachments/assets/183dfbc9-10d2-4738-bf7b-703a2e4909f2)

## 🔧 Mejoras Técnicas Implementadas

### **Arquitectura del Código**
- **Separación de responsabilidades** con archivos de constantes
- **Widgets reutilizables** para mejor mantenimiento
- **Validaciones robustas** en tiempo real
- **Manejo de errores** mejorado
- **Estados de carga** apropiados

### **Experiencia de Usuario**
- **Flujo intuitivo** para login y registro
- **Validaciones visuales** inmediatas
- **Mensajes de error** descriptivos
- **Guías contextuales** integradas
- **Feedback visual** consistente

### **Mejoras de Rendimiento**
- **Lazy loading** de widgets
- **Optimización de rebuild** con setState específico
- **Validación eficiente** de campos
- **Manejo de memoria** mejorado

## 📦 Descarga la Aplicación

### APK para Android
Puedes descargar la última versión de la aplicación desde el siguiente enlace:

**[📱 Descargar APK](https://mega.nz/file/OFhATZRJ#QBA7ngp8VIOfsuSvwOlKc_hHiUlwjXocqqhBw4azY0o)**

## 🤝 Contribuir

Si quieres contribuir al proyecto:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🐛 Reportar Problemas

Si encuentras algún problema:

1. Verifica que no esté ya reportado en Issues
2. Crea un nuevo Issue con:
   - Descripción detallada del problema
   - Pasos para reproducirlo
   - Capturas de pantalla si es necesario
   - Información del dispositivo

## 📊 Estado del Proyecto

- ✅ **Sistema de Login/Registro**: Completamente renovado
- ✅ **Página de Ayuda**: Implementada
- ✅ **Validaciones**: Mejoradas
- ✅ **UI/UX**: Modernizada
- 🔄 **Próximas mejoras**: Notificaciones, modo oscuro, búsqueda

---

**Desarrollado con ❤️ usando Flutter**

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
 - **Nicolas Luna**

