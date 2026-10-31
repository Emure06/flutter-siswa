import 'package:flutter/material.dart';

import 'pages/dashboard.dart';
import 'pages/page_atur_data_siswa.dart';
import 'pages/page_login.dart';
import 'pages/page_view_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata Siswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const Dashboard(),
        '/view-user': (context) => const ViewUserPage(),
        '/atur-data-siswa': (context) => const AturDataSiswaPage(),
      },
    );
  }
}
