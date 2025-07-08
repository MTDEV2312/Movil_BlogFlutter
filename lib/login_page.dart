// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'blog_page.dart';
import 'pages/help_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Controladores para Login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Controladores para Registro
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final supabase = Supabase.instance.client;
  String selectedRole = 'Visitante'; // Rol por defecto

  // Control de pestañas
  late TabController _tabController;

  // Estados de validación
  bool _isLoginLoading = false;
  bool _isRegisterLoading = false;
  bool _loginEmailValid = false;
  bool _loginPasswordValid = false;
  bool _registerEmailValid = false;
  bool _registerPasswordValid = false;
  bool _confirmPasswordValid = false;

  // Mensajes de validación
  String? _loginEmailError;
  String? _loginPasswordError;
  String? _registerEmailError;
  String? _registerPasswordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Validación de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Validación de contraseña
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  // Validar campos de login
  void _validateLoginFields() {
    setState(() {
      _loginEmailError = null;
      _loginPasswordError = null;

      if (loginEmailController.text.isEmpty) {
        _loginEmailError = 'El email es requerido';
        _loginEmailValid = false;
      } else if (!_isValidEmail(loginEmailController.text)) {
        _loginEmailError = 'Formato de email inválido';
        _loginEmailValid = false;
      } else {
        _loginEmailValid = true;
      }

      if (loginPasswordController.text.isEmpty) {
        _loginPasswordError = 'La contraseña es requerida';
        _loginPasswordValid = false;
      } else if (!_isValidPassword(loginPasswordController.text)) {
        _loginPasswordError = 'Mínimo 6 caracteres';
        _loginPasswordValid = false;
      } else {
        _loginPasswordValid = true;
      }
    });
  }

  // Validar campos de registro
  void _validateRegisterFields() {
    setState(() {
      _registerEmailError = null;
      _registerPasswordError = null;
      _confirmPasswordError = null;

      if (registerEmailController.text.isEmpty) {
        _registerEmailError = 'El email es requerido';
        _registerEmailValid = false;
      } else if (!_isValidEmail(registerEmailController.text)) {
        _registerEmailError = 'Formato de email inválido';
        _registerEmailValid = false;
      } else {
        _registerEmailValid = true;
      }

      if (registerPasswordController.text.isEmpty) {
        _registerPasswordError = 'La contraseña es requerida';
        _registerPasswordValid = false;
      } else if (!_isValidPassword(registerPasswordController.text)) {
        _registerPasswordError = 'Mínimo 6 caracteres';
        _registerPasswordValid = false;
      } else {
        _registerPasswordValid = true;
      }

      if (confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Confirma tu contraseña';
        _confirmPasswordValid = false;
      } else if (confirmPasswordController.text !=
          registerPasswordController.text) {
        _confirmPasswordError = 'Las contraseñas no coinciden';
        _confirmPasswordValid = false;
      } else {
        _confirmPasswordValid = true;
      }
    });
  }

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
    _validateLoginFields();

    if (!_loginEmailValid || !_loginPasswordValid) {
      return;
    }

    setState(() {
      _isLoginLoading = true;
    });

    try {
      final response = await supabase.auth.signInWithPassword(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de autenticación: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de base de datos: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Error al iniciar sesión';
        if (e.toString().contains('SocketException') ||
            e.toString().contains('Failed host lookup')) {
          errorMessage = 'Error de conexión. Verifica tu conexión a internet';
        } else if (e.toString().contains('ClientException')) {
          errorMessage = 'Error de conexión con el servidor';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoginLoading = false;
        });
      }
    }
  }

  Future<void> signup() async {
    _validateRegisterFields();

    if (!_registerEmailValid ||
        !_registerPasswordValid ||
        !_confirmPasswordValid) {
      return;
    }

    setState(() {
      _isRegisterLoading = true;
    });

    try {
      final response = await supabase.auth.signUp(
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
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
                'email': registerEmailController.text.trim(),
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

          // Limpiar campos después del registro exitoso
          registerEmailController.clear();
          registerPasswordController.clear();
          confirmPasswordController.clear();
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
    } finally {
      if (mounted) {
        setState(() {
          _isRegisterLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color wineColor = Color(0xFF722F37);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header con logo
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Botón de ayuda en la esquina superior derecha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HelpPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.help_outline, color: wineColor),
                        tooltip: 'Ayuda',
                      ),
                    ],
                  ),

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
                  const SizedBox(height: 20),
                  // Título
                  const Text(
                    'Blog Turístico',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: wineColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comparte tus experiencias de viaje',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Pestañas
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
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
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: wineColor,
                      unselectedLabelColor: Colors.grey[600],
                      indicatorColor: wineColor,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(icon: Icon(Icons.login), text: 'Iniciar Sesión'),
                        Tab(icon: Icon(Icons.person_add), text: 'Registrarse'),
                      ],
                    ),
                  ),

                  // Tab Views
                  SizedBox(
                    height: 500,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Login Tab
                        _buildLoginTab(wineColor),
                        // Register Tab
                        _buildRegisterTab(wineColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Footer
            Text(
              'Únete a nuestra comunidad de viajeros',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget para la pestaña de Login
  Widget _buildLoginTab(Color wineColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instrucciones
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ingresa tus credenciales para acceder a tu cuenta',
                    style: TextStyle(color: Colors.blue[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Campo Email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Correo electrónico',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: loginEmailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _validateLoginFields(),
                decoration: InputDecoration(
                  hintText: 'ejemplo@correo.com',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: _loginEmailError != null ? Colors.red : wineColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _loginEmailError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _loginEmailError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _loginEmailError != null ? Colors.red : wineColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFCFBFA),
                  errorText: _loginEmailError,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Campo Contraseña
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contraseña',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: loginPasswordController,
                obscureText: true,
                onChanged: (value) => _validateLoginFields(),
                decoration: InputDecoration(
                  hintText: 'Mínimo 6 caracteres',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: _loginPasswordError != null ? Colors.red : wineColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _loginPasswordError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _loginPasswordError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _loginPasswordError != null
                          ? Colors.red
                          : wineColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFCFBFA),
                  errorText: _loginPasswordError,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Botón Iniciar Sesión
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoginLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: wineColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: _isLoginLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // Enlace de ayuda
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
              child: Text(
                '¿Necesitas ayuda?',
                style: TextStyle(
                  color: wineColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para la pestaña de Registro
  Widget _buildRegisterTab(Color wineColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instrucciones
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Crea tu cuenta y únete a nuestra comunidad',
                    style: TextStyle(color: Colors.green[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Campo Email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Correo electrónico',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: registerEmailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _validateRegisterFields(),
                decoration: InputDecoration(
                  hintText: 'ejemplo@correo.com',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: _registerEmailError != null ? Colors.red : wineColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _registerEmailError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _registerEmailError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _registerEmailError != null
                          ? Colors.red
                          : wineColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFCFBFA),
                  errorText: _registerEmailError,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Campo Contraseña
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contraseña',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: registerPasswordController,
                obscureText: true,
                onChanged: (value) => _validateRegisterFields(),
                decoration: InputDecoration(
                  hintText: 'Mínimo 6 caracteres',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: _registerPasswordError != null
                        ? Colors.red
                        : wineColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _registerPasswordError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _registerPasswordError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _registerPasswordError != null
                          ? Colors.red
                          : wineColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFCFBFA),
                  errorText: _registerPasswordError,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Campo Confirmar Contraseña
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirmar contraseña',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                onChanged: (value) => _validateRegisterFields(),
                decoration: InputDecoration(
                  hintText: 'Repite tu contraseña',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: _confirmPasswordError != null
                        ? Colors.red
                        : wineColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Colors.red
                          : wineColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFCFBFA),
                  errorText: _confirmPasswordError,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Selector de rol
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tipo de cuenta',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
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
                    // Mostrar rol seleccionado
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: wineColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: wineColor.withOpacity(0.3)),
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
                              'Seleccionado: $selectedRole',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        RadioListTile<String>(
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
                        RadioListTile<String>(
                          title: const Text('Escritor'),
                          subtitle: const Text('Escribir y publicar artículos'),
                          value: 'Publicador',
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                          activeColor: wineColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Botón Registrarse
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isRegisterLoading ? null : signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: wineColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: _isRegisterLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // Información adicional
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.mail_outline, color: Colors.orange[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recibirás un correo de confirmación después del registro',
                    style: TextStyle(color: Colors.orange[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
