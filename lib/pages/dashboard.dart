import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/ui_helper.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  void _logout(BuildContext context) {
    ApiService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final username = ApiService.currentUser?['username'] ?? '';

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.dashboard, color: kPrimary),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  color: kPrimary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          if (username.toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Halo, $username',
                  style: const TextStyle(fontSize: 16, color: kPrimary),
                ),
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
                  onTap: () => Navigator.pushNamed(context, '/view-user'),
                ),
                menuCard(
                  icon: Icons.manage_accounts_outlined,
                  title: 'Atur Data Siswa',
                  onTap: () => Navigator.pushNamed(context, '/atur-data-siswa'),
                ),
                menuCard(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => _logout(context),
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
              Icon(icon, size: 28, color: kPrimary),
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
