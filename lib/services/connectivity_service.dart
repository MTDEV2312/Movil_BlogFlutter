import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ConnectivityService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final Connectivity _connectivity = Connectivity();

  // Detectar si estamos en un emulador
  static Future<bool> isEmulator() async {
    if (kIsWeb) return false;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;

        // Detectar BlueStacks y otros emuladores
        final brand = androidInfo.brand.toLowerCase();
        final model = androidInfo.model.toLowerCase();
        final product = androidInfo.product.toLowerCase();
        final manufacturer = androidInfo.manufacturer.toLowerCase();

        return brand.contains('generic') ||
            brand.contains('google') ||
            brand.contains('bluestacks') ||
            model.contains('sdk') ||
            model.contains('emulator') ||
            model.contains('bluestacks') ||
            product.contains('sdk') ||
            product.contains('emulator') ||
            manufacturer.contains('genymotion') ||
            androidInfo.isPhysicalDevice == false;
      }

      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return !iosInfo.isPhysicalDevice;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error detecting emulator: $e');
      }
    }

    return false;
  }

  // Verificar conectividad
  static Future<bool> hasConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking connectivity: $e');
      }
      return false;
    }
  }

  // Verificar conexión a internet real
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('No internet connection: $e');
      }
      return false;
    }
  }

  // Obtener configuración específica para emuladores
  static Future<Map<String, dynamic>> getConnectionConfig() async {
    final isEmu = await isEmulator();

    if (isEmu) {
      return {
        'timeout': 30, // Timeout más largo para emuladores
        'retries': 5,
        'delay': 3000, // Delay entre reintentos
        'isEmulator': true,
      };
    }

    return {'timeout': 10, 'retries': 3, 'delay': 1000, 'isEmulator': false};
  }
}
