import 'package:flutter/material.dart';

class AppBarPage extends StatelessWidget {
  const AppBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Halaman AppBar'),
      centerTitle: true,
      backgroundColor: Colors.lightBlueAccent,
      foregroundColor: const Color.fromARGB(255, 253, 253, 253),
    );
  }
}