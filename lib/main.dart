import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:turistic_blog/blog_page.dart';
import 'package:turistic_blog/login_page.dart';
import 'package:turistic_blog/services/connectivity_service.dart';
import 'package:turistic_blog/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar HttpOverrides para problemas de SSL en emuladores
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }

  runApp(const MyApp());
}

// Clase para manejar problemas de certificados SSL en emuladores
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Solo permitir certificados problemáticos en modo debug y para Supabase
        if (kDebugMode &&
            (host.contains('supabase.co') || host.contains('supabase.io'))) {
          return true;
        }
        return false;
      };
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _statusMessage = 'Inicializando aplicación...';

  late final StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() {
      _isInitialized = false;
      _hasError = false;
      _statusMessage = 'Verificando conectividad...';
    });

    try {
      // Verificar si estamos en un emulador
      final isEmulator = await ConnectivityService.isEmulator();
      final config = await ConnectivityService.getConnectionConfig();

      if (kDebugMode) {
        print('🔍 Ejecutándose en emulador: $isEmulator');
        print('🔧 Configuración: $config');
      }

      setState(() {
        _statusMessage = isEmulator
            ? 'Detectado emulador, configurando conexión...'
            : 'Verificando conexión a internet...';
      });

      // Verificar conectividad
      final hasConnection = await ConnectivityService.hasConnection();
      if (!hasConnection) {
        throw Exception('No hay conexión a internet disponible');
      }

      setState(() {
        _statusMessage = 'Conectando a Supabase...';
      });

      // Intentar inicializar Supabase con reintentos
      await _initializeSupabaseWithRetries(config);

      setState(() {
        _statusMessage = 'Configurando autenticación...';
      });

      // Configurar el listener de autenticación
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange
          .listen((data) {
            if (mounted) {
              setState(() {});
            }
          });

      setState(() {
        _isInitialized = true;
        _hasError = false;
        _statusMessage = 'Aplicación lista';
      });

      if (kDebugMode) {
        print('✅ Aplicación inicializada correctamente');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isInitialized = false;
        _errorMessage = _getErrorMessage(e);
      });

      if (kDebugMode) {
        print('❌ Error inicializando aplicación: $e');
      }
    }
  }

  Future<void> _initializeSupabaseWithRetries(
    Map<String, dynamic> config,
  ) async {
    final maxRetries = config['retries'] as int;
    final timeoutSeconds = config['timeout'] as int;
    final delayMs = config['delay'] as int;

    for (int i = 0; i < maxRetries; i++) {
      try {
        await Supabase.initialize(
          url: 'https://your-project.supabase.co', // Reemplaza con tu URL de Supabase
          anonKey:
              'your-anon-key-here', // Reemplaza con tu clave anon
          debug: kDebugMode,
        );

        // Verificar que Supabase está funcionando con un timeout
        await Supabase.instance.client
            .from('user_profiles')
            .select('count')
            .limit(1)
            .timeout(Duration(seconds: timeoutSeconds));

        if (kDebugMode) {
          print('✅ Supabase inicializado correctamente en intento ${i + 1}');
        }

        return; // Éxito, salir del bucle
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error en intento ${i + 1}: $e');
        }

        if (i < maxRetries - 1) {
          setState(() {
            _statusMessage = 'Reintentando conexión... (${i + 1}/$maxRetries)';
          });
          await Future.delayed(Duration(milliseconds: delayMs));
        } else {
          throw Exception(
            'No se pudo conectar después de $maxRetries intentos: $e',
          );
        }
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('socket') || errorStr.contains('network')) {
      return 'Error de red. Verifica tu conexión a internet y que BlueStacks tenga acceso a la red.';
    } else if (errorStr.contains('timeout')) {
      return 'Tiempo de espera agotado. Esto es común en emuladores como BlueStacks.';
    } else if (errorStr.contains('ssl') || errorStr.contains('certificate')) {
      return 'Error de certificado SSL. Reinicia BlueStacks e inténtalo de nuevo.';
    } else if (errorStr.contains('connection refused')) {
      return 'Conexión rechazada. Verifica la configuración de red en BlueStacks.';
    } else {
      return 'Error de conexión: ${error.toString()}';
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Turístico',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFF722F37),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF722F37),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: _buildHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildHomePage() {
    // Mostrar splash screen mientras se inicializa
    if (!_isInitialized) {
      return SplashScreen(
        message: _statusMessage,
        showError: _hasError,
        errorMessage: _hasError ? _errorMessage : null,
        onRetry: _hasError ? _initializeApp : null,
        isLoading: !_hasError,
      );
    }

    // Una vez inicializado, determinar la página apropiada
    try {
      final supabase = Supabase.instance.client;
      return supabase.auth.currentUser != null
          ? const BlogPage()
          : const LoginPage();
    } catch (e) {
      // Si hay error accediendo a Supabase, ir a login
      return const LoginPage();
    }
  }
}
