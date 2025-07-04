import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:turistic_blog/blog_page.dart';
import 'package:turistic_blog/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'your_supabase_url',
      anonKey:
          'your_supabase_anon_key',
      debug: false,
    );
  } catch (e) {
    // Error silencioso - la app manejará errores de conexión cuando sea necesario
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el estado de autenticación
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Blog Personal',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFF722F37),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF722F37),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: supabase.auth.currentUser != null
          ? const BlogPage()
          : const LoginPage(),
    );
  }
}
