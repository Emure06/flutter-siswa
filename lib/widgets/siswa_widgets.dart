import 'package:flutter/material.dart';

import '../models/siswa.dart';
import '../utils/ui_helper.dart';

class SiswaCard extends StatelessWidget {
  final Siswa siswa;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SiswaCard({super.key, required this.siswa, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    final inisial =
        siswa.namaLengkap.isNotEmpty ? siswa.namaLengkap[0].toUpperCase() : '?';

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: CircleAvatar(
          backgroundColor: kBackground,
          child: Text(
            inisial,
            style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          siswa.namaLengkap,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${siswa.kelas} ${siswa.jurusan}  •  NIPD: ${siswa.nipd ?? '-'}',
        ),
        trailing: trailing,
      ),
    );
  }
}

void showSiswaDetail(BuildContext context, Siswa siswa) {
  Widget row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(label, style: const TextStyle(color: Colors.black54)),
            ),
            Expanded(
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            siswa.namaLengkap,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kPrimary,
            ),
          ),
          const SizedBox(height: 12),
          row('NIPD', siswa.nipd ?? '-'),
          row('Jenis kelamin', siswa.jenisKelamin),
          row('Kelas', siswa.kelas),
          row('Jurusan', siswa.jurusan),
          row('Alamat', siswa.alamat),
        ],
      ),
    ),
  );
}

/// Tampilan kosong / error di tengah layar (bisa di-scroll agar
/// pull-to-refresh tetap berfungsi).
class MessageView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const MessageView({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 80),
        Icon(icon, size: 56, color: kPrimary.withAlpha(140)),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center),
        if (actionLabel != null) ...[
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ),
        ],
      ],
    );
  }
}
