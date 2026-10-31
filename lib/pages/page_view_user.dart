import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({super.key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  late Future<List<dynamic>> futureUser;

  // Alamat API (otomatis sesuai perangkat)
  // Chrome / Windows : localhost
  // Emulator Android : 10.0.2.2
  // HP fisik         : ganti manual jadi 'http://IP_LAPTOP:3001/api'
  String get baseUrl {
    if (kIsWeb) return 'http://localhost:3001/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3001/api';
    }
    return 'http://localhost:3001/api';
  }

  @override
  void initState() {
    super.initState();
    futureUser = getDataUser(); // dipanggil sekali, bukan tiap build
  }

  Future<List<dynamic>> getDataUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    debugPrint('TOKEN: $token');

    if (token == null) {
      throw Exception("Token tidak ada, silakan login dulu");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users?limit=100'), // maksimal 100 data per request
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> listUser = data['data'];
      return listUser;
    } else if (response.statusCode == 401) {
      debugPrint("Token tidak valid / kadaluarsa");
      throw Exception("Token tidak valid / kadaluarsa, silakan login ulang");
    } else {
      debugPrint("Gagal Memuat Data Users");
      throw Exception("Failed to read data users (${response.statusCode})");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: futureUser,
        builder: (context, snapshot) {
          // 1. Masih loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Ada error
          else if (snapshot.hasError) {
            debugPrint('Terjadi Error: ${snapshot.error}');
            return Center(child: Text('Terjadi Error: ${snapshot.error}'));
          }

          // 3. Data kosong atau null
          else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data kosong.'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user['id'].toString()),
                ),
                title: Text(user['nama'] ?? '-'), // kolom di database: nama
                subtitle: Text(user['email'] ?? '-'),
              );
            },
          );
        },
      ),
    );
  }
}