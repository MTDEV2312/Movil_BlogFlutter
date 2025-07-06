// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'blog_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  String selectedRole = 'Visitante'; // Rol por defecto

  // Método para verificar el rol guardado
  Future<String?> verifyUserRole(String userId) async {
    try {
      final response = await supabase
          .from('user_profiles')
          .select('role')
          .eq('user_id', userId)
          .single();
      return response['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<void> login() async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user != null) {
        // Verificar que el usuario existe en la base de datos
        await supabase
            .from('user_profiles')
            .select('role')
            .eq('user_id', response.user!.id)
            .single();

        // Navegar a la página principal
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BlogPage()),
          );
        }
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de autenticación: ${e.message}')),
      );
    } on PostgrestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de base de datos: ${e.message}')),
      );
    } catch (e) {
      String errorMessage = 'Error al iniciar sesión';
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage = 'Error de conexión. Verifica tu conexión a internet';
      } else if (e.toString().contains('ClientException')) {
        errorMessage = 'Error de conexión con el servidor';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$errorMessage: $e')));
    }
  }

  Future<void> signup() async {
    try {
      final response = await supabase.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.user != null) {
        try {
          // Usar la nueva función que maneja tanto inserción como actualización
          await supabase.rpc(
            'set_user_role_on_signup',
            params: {
              'user_id_param': response.user!.id,
              'new_role': selectedRole,
            },
          );
        } catch (roleError) {
          // Fallback: esperar un momento y luego intentar actualización directa
          await Future.delayed(const Duration(milliseconds: 1000));

          try {
            await supabase
                .from('user_profiles')
                .update({'role': selectedRole})
                .eq('user_id', response.user!.id);
          } catch (directError) {
            // Último recurso: crear el perfil manualmente
            try {
              await supabase.from('user_profiles').upsert({
                'user_id': response.user!.id,
                'email': emailController.text,
                'role': selectedRole,
              });
            } catch (upsertError) {
              // Error silencioso para upsert
            }
          }
        }

        // Verificar que el rol se guardó correctamente
        await Future.delayed(const Duration(milliseconds: 500));
        final savedRole = await verifyUserRole(response.user!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                savedRole != null
                    ? 'Cuenta creada como $savedRole. Revisa tu correo para confirmar.'
                    : 'Cuenta creada como $selectedRole. Revisa tu correo para confirmar.',
              ),
              backgroundColor: savedRole == selectedRole
                  ? Colors.green
                  : Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrarse: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color wineColor = Color(0xFF722F37);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo o icono principal para blog
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: wineColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: wineColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_note,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              // Título
              const Text(
                'Blog Turistico',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: wineColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Comparte tus ideas y conecta con otros',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // Formulario
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Campo Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: wineColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: wineColor,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFCFBFA),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo Contraseña
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: wineColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: wineColor,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFCFBFA),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Botón Iniciar Sesión
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: wineColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'o',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Selector de rol mejorado para blog
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: wineColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: wineColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: wineColor,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Tipo de cuenta para el blog:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: wineColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Mostrar rol seleccionado claramente
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: wineColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: wineColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  selectedRole == 'Visitante'
                                      ? Icons.visibility
                                      : Icons.edit,
                                  color: wineColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Rol seleccionado: $selectedRole',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: wineColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: selectedRole == 'Visitante'
                                      ? wineColor.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: selectedRole == 'Visitante'
                                      ? Border.all(
                                          color: wineColor.withOpacity(0.3),
                                        )
                                      : null,
                                ),
                                child: RadioListTile<String>(
                                  title: const Text('Lector'),
                                  subtitle: const Text(
                                    'Solo leer artículos y comentarios',
                                  ),
                                  value: 'Visitante',
                                  groupValue: selectedRole,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value!;
                                    });
                                  },
                                  activeColor: wineColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: selectedRole == 'Publicador'
                                      ? wineColor.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: selectedRole == 'Publicador'
                                      ? Border.all(
                                          color: wineColor.withOpacity(0.3),
                                        )
                                      : null,
                                ),
                                child: RadioListTile<String>(
                                  title: const Text('Escritor'),
                                  subtitle: const Text(
                                    'Escribir y publicar artículos',
                                  ),
                                  value: 'Publicador',
                                  groupValue: selectedRole,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value!;
                                    });
                                  },
                                  activeColor: wineColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botón Registrarse
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: signup,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: wineColor,
                          side: const BorderSide(color: wineColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Footer
              Text(
                'Únete a nuestra comunidad de escritores',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
