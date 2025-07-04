import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../models/blog_post.dart';

class BlogService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final ImagePicker _picker = ImagePicker();

  // Obtener todos los posts del blog
  static Future<List<BlogPost>> getAllPosts() async {
    try {
      final response = await _supabase
          .from('blog_posts')
          .select('*, reviews(*)')
          .order('created_at', ascending: false);

      return (response as List).map((post) => BlogPost.fromJson(post)).toList();
    } catch (e) {
      return [];
    }
  }

  // Crear un nuevo post
  static Future<bool> createPost({
    required String title,
    required String content,
    required String location,
    required List<XFile> images,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Validar que hay al menos 5 imágenes
      if (images.length < 5) {
        throw Exception('Se requieren al menos 5 imágenes');
      }

      // Subir imágenes
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        final file = File(images[i].path);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final path = 'blog_images/${user.id}/$fileName';

        await _supabase.storage.from('blog-images').upload(path, file);

        final imageUrl = _supabase.storage
            .from('blog-images')
            .getPublicUrl(path);
        imageUrls.add(imageUrl);
      }

      // Crear el post
      await _supabase.from('blog_posts').insert({
        'title': title,
        'content': content,
        'location': location,
        'author_id': user.id,
        'author_email': user.email,
        'image_urls': imageUrls,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Seleccionar imágenes (cámara o galería)
  static Future<List<XFile>?> pickImages({bool fromCamera = false}) async {
    try {
      if (fromCamera) {
        // Solicitar permisos de cámara
        final cameraPermission = await Permission.camera.request();
        if (cameraPermission.isPermanentlyDenied) {
          await openAppSettings();
          return null;
        }
        if (!cameraPermission.isGranted) {
          throw Exception('Permiso de cámara requerido para tomar fotos');
        }

        final image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80, // Reducir calidad para optimizar tamaño
          maxWidth: 1920,
          maxHeight: 1080,
        );
        return image != null ? [image] : null;
      } else {
        // Solicitar permisos de almacenamiento según la versión de Android
        PermissionStatus permission;

        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            // Android 13+ (API 33+)
            permission = await Permission.photos.request();
          } else {
            // Android 12 y anteriores
            permission = await Permission.storage.request();
          }
        } else {
          // iOS
          permission = await Permission.photos.request();
        }

        if (permission.isPermanentlyDenied) {
          await openAppSettings();
          return null;
        }

        if (!permission.isGranted) {
          throw Exception(
            'Permiso de almacenamiento requerido para acceder a las fotos',
          );
        }

        return await _picker.pickMultiImage(
          imageQuality: 80, // Reducir calidad para optimizar tamaño
          maxWidth: 1920,
          maxHeight: 1080,
        );
      }
    } catch (e) {
      rethrow; // Re-lanzar la excepción para que el UI pueda manejarla
    }
  }

  // Validar formato de imagen
  static bool validateImageFormat(XFile image) {
    final allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    final fileName = image.name.toLowerCase();

    return allowedExtensions.any((ext) => fileName.endsWith(ext));
  }

  // Validar imagen (solo formato)
  static Future<Map<String, dynamic>> validateImage(XFile image) async {
    // Validar formato
    if (!validateImageFormat(image)) {
      return {
        'isValid': false,
        'error': 'Formato no permitido. Solo se permiten: JPG, JPEG, PNG, WEBP',
      };
    }

    return {'isValid': true, 'error': null};
  }

  // Crear una reseña
  static Future<bool> createReview({
    required String postId,
    required String content,
    required int rating,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('reviews').insert({
        'post_id': postId,
        'author_id': user.id,
        'author_email': user.email,
        'content': content,
        'rating': rating,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Responder a una reseña
  static Future<bool> replyToReview({
    required String reviewId,
    required String content,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('review_replies').insert({
        'review_id': reviewId,
        'author_id': user.id,
        'author_email': user.email,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtener reseñas de un post
  static Future<List<Review>> getReviewsForPost(String postId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*, review_replies(*)')
          .eq('post_id', postId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((review) => Review.fromJson(review))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Obtener un post específico
  static Future<BlogPost?> getPost(String postId) async {
    try {
      final response = await _supabase
          .from('blog_posts')
          .select('*, reviews(*)')
          .eq('id', postId)
          .single();

      return BlogPost.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}
