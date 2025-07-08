import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color wineColor = Color(0xFF722F37);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
        backgroundColor: wineColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Registro
            _buildSection(
              title: '📝 Cómo Registrarse',
              content: [
                '1. Ve a la pestaña "Registrarse"',
                '2. Ingresa tu correo electrónico válido',
                '3. Crea una contraseña segura (mínimo 6 caracteres)',
                '4. Confirma tu contraseña',
                '5. Selecciona tu tipo de cuenta:',
                '   • Lector: Solo puedes leer artículos',
                '   • Escritor: Puedes escribir y publicar artículos',
                '6. Presiona "Crear Cuenta"',
                '7. Revisa tu correo para confirmar tu cuenta',
              ],
            ),

            const SizedBox(height: 20),

            // Sección de Inicio de Sesión
            _buildSection(
              title: '🔑 Cómo Iniciar Sesión',
              content: [
                '1. Ve a la pestaña "Iniciar Sesión"',
                '2. Ingresa tu correo electrónico registrado',
                '3. Ingresa tu contraseña',
                '4. Presiona "Iniciar Sesión"',
                '',
                '⚠️ Importante: Debes haber confirmado tu correo antes de poder iniciar sesión',
              ],
            ),

            const SizedBox(height: 20),

            // Sección de Tipos de Cuenta
            _buildSection(
              title: '👥 Tipos de Cuenta',
              content: [
                '• Lector (Visitante):',
                '  - Puede leer todos los artículos',
                '  - Puede ver comentarios y reseñas',
                '  - No puede publicar contenido',
                '',
                '• Escritor (Publicador):',
                '  - Puede hacer todo lo que hace un Lector',
                '  - Puede escribir y publicar artículos',
                '  - Puede subir imágenes a sus artículos',
                '  - Puede escribir sobre destinos turísticos',
              ],
            ),

            const SizedBox(height: 20),

            // Sección de Problemas Comunes
            _buildSection(
              title: '🔧 Problemas Comunes',
              content: [
                '• "No puedo iniciar sesión":',
                '  - Verifica que tu correo esté confirmado',
                '  - Revisa que tu contraseña sea correcta',
                '  - Verifica tu conexión a internet',
                '',
                '• "No recibí el correo de confirmación":',
                '  - Revisa tu carpeta de spam',
                '  - Espera unos minutos y vuelve a intentar',
                '  - Verifica que el correo esté escrito correctamente',
                '',
                '• "Olvidé mi contraseña":',
                '  - Contacta al administrador del sistema',
                '  - Por ahora no hay recuperación automática',
              ],
            ),
            const SizedBox(height: 30),

            // Botón de cerrar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: wineColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF722F37),
            ),
          ),
          const SizedBox(height: 12),
          ...content.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
