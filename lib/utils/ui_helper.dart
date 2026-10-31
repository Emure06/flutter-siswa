import 'package:flutter/material.dart';

import '../services/api_service.dart';

const Color kPrimary = Color(0xFF34546A);
const Color kBackground = Color(0xFFEAF4FF);

void showSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red.shade700 : kPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
}

/// Menampilkan error dari API. Kalau token habis / tidak valid (401),
/// otomatis kembali ke halaman login.
void handleApiError(BuildContext context, Object e) {
  if (!context.mounted) return;

  if (e is ApiException && e.isUnauthorized) {
    final messenger = ScaffoldMessenger.of(context);
    ApiService.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Sesi habis, silakan login ulang'),
        backgroundColor: Colors.red.shade700,
      ),
    );
    return;
  }

  showSnack(
    context,
    e is ApiException ? e.message : 'Terjadi kesalahan: $e',
    error: true,
  );
}
