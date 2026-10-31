import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {

  static const String manualBaseUrl = '';

  static String get baseUrl {
    if (manualBaseUrl.isNotEmpty) return manualBaseUrl;
    if (kIsWeb) return 'http://localhost:3000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/api'; // emulator Android
    return 'http://localhost:3000/api'; 
  }
}
