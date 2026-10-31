import 'package:flutter/material.dart';

class AppBodyPage extends StatefulWidget {
  const AppBodyPage({super.key});

  @override
  State<AppBodyPage> createState() => _AppBodyPageState();
}

class _AppBodyPageState extends State<AppBodyPage> {
  final TextEditingController _controller = TextEditingController();
  String _hasil = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tampilkan(String namaButton) {
    setState(() {
      _hasil = '$namaButton: ${_controller.text}';
    });
    print(_hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _hasil,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Ketik sesuatu',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _tampilkan('Jembod 1'),
                child: const Text('Jembod 1'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _tampilkan('Jembod 2'),
                child: const Text('Jembod 2'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _tampilkan('Jembod 3'),
                child: const Text('Jembod 3'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}