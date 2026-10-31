import 'package:flutter/material.dart';

class Baris extends StatelessWidget {
  const Baris({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Text(
          'Selamat Datang',
          style: TextStyle(
            fontSize: 35,
            color: Color.fromARGB(255, 0, 174, 171), 
          ),
        ),
      ],
    );
  }
}