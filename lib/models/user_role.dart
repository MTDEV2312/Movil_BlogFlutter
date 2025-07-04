enum UserRole {
  visitante('Visitante', 'Puede visualizar ubicaciones y contenido'),
  publicador('Publicador', 'Puede crear, editar y gestionar contenido');

  const UserRole(this.displayName, this.description);

  final String displayName;
  final String description;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'visitante':
        return UserRole.visitante;
      case 'publicador':
        return UserRole.publicador;
      default:
        return UserRole.visitante; // Por defecto
    }
  }
}

class UserProfile {
  final String userId;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  UserProfile({
    required this.userId,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'],
      email: json['email'],
      role: UserRole.fromString(json['role']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'role': role.displayName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get canPublish => role == UserRole.publicador;
  bool get canWriteReviews =>
      true; // Todos los usuarios autenticados pueden escribir reseñas
  bool get canView => true; // Todos pueden ver
}
