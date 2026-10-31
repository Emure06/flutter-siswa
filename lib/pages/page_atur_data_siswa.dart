import 'package:flutter/material.dart';

class AturDataSiswaPage extends StatelessWidget {
  const AturDataSiswaPage({super.key});

  void _info(BuildContext context, String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF4FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF34546A)),
        title: const Text(
          'Atur Data Siswa',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF34546A),
          ),
        ),
      ),

      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          menuCard(
            icon: Icons.add_box_outlined,
            title: 'Input Data',
            onTap: () => _info(context, 'Halaman input belum dibuat'),
          ),
          menuCard(
            icon: Icons.edit_note,
            title: 'Update Data',
            onTap: () => _info(context, 'Halaman update belum dibuat'),
          ),
          menuCard(
            icon: Icons.delete_outline,
            title: 'Delete Data',
            onTap: () => _info(context, 'Fitur hapus belum dibuat'),
          ),
        ],
      ),
    );
  }

  Widget menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF34546A)),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}