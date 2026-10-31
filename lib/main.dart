
import 'package:flutter/material.dart';

import 'pages/app_bar.dart';
import 'pages/app_body.dart';
import 'pages/appcolumn.dart';
import 'pages/baris.dart';
import 'pages/page_input.dart';
import 'pages/page_login.dart';
import 'pages/dashboard.dart';
import 'pages/page_update.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      initialRoute: '/logi',

      routes: {
        '/': (context) => const HomePage(),
        '/app-bar': (context) => const AppBarPage(),
        '/app-body': (context) => const AppBodyPage(),
        '/app-column': (context) => const AppColumnPage(),
        '/baris': (context) => const Baris(),
        '/input': (context) => const InputDataSiswa(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const Dashboard(),
        '/update': (context) => const UpdateDataSiswa(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            routeButton(context, 'App Bar', '/app-bar'),
            routeButton(context, 'App Body', '/app-body'),
            routeButton(context, 'App Column', '/app-column'),
            routeButton(context, 'Baris', '/baris'),
            routeButton(context, 'Input', '/input'),
            routeButton(context, 'Login', '/login'),
            routeButton(context, 'Dashboard', '/dashboard'),
            routeButton(context, 'Update', '/update'),
          ],
        ),
      ),
    );
  }

  Widget routeButton(
    BuildContext context,
    String title,
    String route,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(title),
      ),
    );
  }
}
