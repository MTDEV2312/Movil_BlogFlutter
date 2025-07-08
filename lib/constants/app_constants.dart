import 'package:flutter/material.dart';

// Colores de la aplicación
class AppColors {
  static const Color wineColor = Color(0xFF722F37);
  static const Color backgroundColor = Color(0xFFFAF9F7);
  static const Color cardColor = Color(0xFFFCFBFA);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}

// Strings de la aplicación
class AppStrings {
  static const String appName = 'Blog Turístico';
  static const String appDescription = 'Comparte tus experiencias de viaje';
  static const String loginTitle = 'Iniciar Sesión';
  static const String registerTitle = 'Registrarse';
  static const String emailLabel = 'Correo electrónico';
  static const String passwordLabel = 'Contraseña';
  static const String confirmPasswordLabel = 'Confirmar contraseña';
  static const String accountTypeLabel = 'Tipo de cuenta';
  static const String readerRole = 'Lector';
  static const String writerRole = 'Escritor';
  static const String readerDescription = 'Solo leer artículos y comentarios';
  static const String writerDescription = 'Escribir y publicar artículos';
  static const String helpButton = '¿Necesitas ayuda?';
  static const String createAccountButton = 'Crear Cuenta';
  static const String loginButton = 'Iniciar Sesión';
  static const String footerText = 'Únete a nuestra comunidad de viajeros';

  // Mensajes de validación
  static const String emailRequired = 'El email es requerido';
  static const String emailInvalid = 'Formato de email inválido';
  static const String passwordRequired = 'La contraseña es requerida';
  static const String passwordMinLength = 'Mínimo 6 caracteres';
  static const String confirmPasswordRequired = 'Confirma tu contraseña';
  static const String passwordsDoNotMatch = 'Las contraseñas no coinciden';

  // Mensajes de información
  static const String loginInstructions =
      'Ingresa tus credenciales para acceder a tu cuenta';
  static const String registerInstructions =
      'Crea tu cuenta y únete a nuestra comunidad';
  static const String confirmationEmailInfo =
      'Recibirás un correo de confirmación después del registro';

  // Placeholders
  static const String emailPlaceholder = 'ejemplo@correo.com';
  static const String passwordPlaceholder = 'Mínimo 6 caracteres';
  static const String confirmPasswordPlaceholder = 'Repite tu contraseña';
}

// Dimensiones y espaciado
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  static const double borderRadius = 12.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 16.0;

  static const double buttonHeight = 50.0;
  static const double iconSize = 20.0;
  static const double iconSizeLarge = 50.0;

  static const double elevationLow = 2.0;
  static const double elevationMedium = 3.0;
  static const double elevationHigh = 5.0;
}

// Estilos de texto
class AppTextStyles {
  static const TextStyle titleLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.wineColor,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.wineColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle captionText = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
