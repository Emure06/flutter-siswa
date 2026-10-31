import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF4FF),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: [
          // Judul Dashboard
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.dashboard, color: Color(0xFF34546A)),

                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF34546A),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  color: const Color(0xFF34546A),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,

              children: [
                menuCard(
                  icon: Icons.visibility_outlined,
                  title: 'Lihat Data',
                  color: Colors.white,
                  onTap: () {
                    Navigator.pushNamed(context, '/view-user');
                  },
                ),

                menuCard(
                  icon: Icons.manage_accounts_outlined,
                  title: 'Atur Data Siswa',
                  color: Colors.white,
                  onTap: () {
                    Navigator.pushNamed(context, '/atur-data-siswa');
                  },
                ),

                menuCard(
                  icon: Icons.arrow_back,
                  title: 'Logout',
                  color: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: color,
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