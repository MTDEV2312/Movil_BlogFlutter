import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_role.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Obtener el perfil del usuario actual
  static Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', user.id)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Verificar si el usuario puede publicar
  static Future<bool> canUserPublish() async {
    final profile = await getCurrentUserProfile();
    return profile?.canPublish ?? false;
  }

  // Verificar si el usuario puede escribir reseñas
  static Future<bool> canUserWriteReviews() async {
    final profile = await getCurrentUserProfile();
    return profile?.canWriteReviews ?? false;
  }

  // Obtener el rol del usuario actual
  static Future<UserRole?> getCurrentUserRole() async {
    final profile = await getCurrentUserProfile();
    return profile?.role;
  }

  // Crear perfil de usuario
  static Future<void> createUserProfile({
    required String userId,
    required String email,
    required UserRole role,
  }) async {
    await _supabase.from('user_profiles').insert({
      'user_id': userId,
      'email': email,
      'role': role.displayName,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Cerrar sesión
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Verificar si el usuario está autenticado
  static bool get isAuthenticated => _supabase.auth.currentUser != null;
}
