import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/siswa.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

class ApiService {
  ApiService._();

  // Token disimpan di memori. Karena aplikasi selalu mulai dari halaman login,
  // token tidak perlu disimpan permanen.
  static String? token;
  static Map<String, dynamic>? currentUser;

  static const _timeout = Duration(seconds: 15);

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Uri _uri(String path, [Map<String, String>? query]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return (query == null || query.isEmpty)
        ? uri
        : uri.replace(queryParameters: query);
  }

  /// Menjalankan request, menangani error jaringan, dan mengubah
  /// respons error API menjadi ApiException dengan pesan yang jelas.
  static Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() call,
  ) async {
    http.Response res;
    try {
      res = await call().timeout(_timeout);
    } on TimeoutException {
      throw ApiException('Server tidak merespons. Pastikan API sudah dijalankan.');
    } on SocketException {
      throw ApiException(
          'Tidak bisa terhubung ke server. Cek alamat API dan koneksi jaringan.');
    } on http.ClientException {
      throw ApiException(
          'Tidak bisa terhubung ke server. Cek alamat API dan koneksi jaringan.');
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respons server tidak valid (${res.statusCode})',
          statusCode: res.statusCode);
    }

    if (res.statusCode >= 200 && res.statusCode < 300) return body;

    final errors = (body['errors'] as List?)
            ?.map((e) => (e as Map)['message'].toString())
            .toList() ??
        <String>[];

    throw ApiException(
      errors.isNotEmpty
          ? errors.join('\n')
          : (body['message'] ?? 'Terjadi kesalahan').toString(),
      statusCode: res.statusCode,
    );
  }

  // ---------- AUTH ----------

  static Future<void> login(String identifier, String password) async {
    final body = await _send(() => http.post(
          _uri('/auth/login'),
          headers: _headers,
          body: jsonEncode({'identifier': identifier, 'password': password}),
        ));
    token = body['data']['token'] as String;
    currentUser = Map<String, dynamic>.from(body['data']['user'] as Map);
  }

  static void logout() {
    token = null;
    currentUser = null;
  }

  // ---------- SISWA ----------

  static Future<List<Siswa>> getSiswa({String search = '', int limit = 100}) async {
    final query = <String, String>{
      'limit': '$limit',
      'sort_by': 'nama_lengkap',
      'order': 'asc',
      if (search.trim().isNotEmpty) 'search': search.trim(),
    };
    final body = await _send(() => http.get(_uri('/siswa', query), headers: _headers));
    return (body['data'] as List)
        .map((e) => Siswa.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> createSiswa(Siswa siswa) async {
    await _send(() => http.post(
          _uri('/siswa'),
          headers: _headers,
          body: jsonEncode(siswa.toJson()),
        ));
  }

  static Future<void> updateSiswa(Siswa siswa) async {
    await _send(() => http.put(
          _uri('/siswa/${siswa.id}'),
          headers: _headers,
          body: jsonEncode(siswa.toJson()),
        ));
  }

  static Future<void> deleteSiswa(int id) async {
    await _send(() => http.delete(_uri('/siswa/$id'), headers: _headers));
  }
}
