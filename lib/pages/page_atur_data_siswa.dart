import 'dart:async';

import 'package:flutter/material.dart';

import '../models/siswa.dart';
import '../services/api_service.dart';
import '../utils/ui_helper.dart';
import '../widgets/siswa_widgets.dart';
import 'page_form_siswa.dart';

/// Halaman ATUR DATA SISWA: tambah, ubah, dan hapus data siswa.
class AturDataSiswaPage extends StatefulWidget {
  const AturDataSiswaPage({super.key});

  @override
  State<AturDataSiswaPage> createState() => _AturDataSiswaPageState();
}

class _AturDataSiswaPageState extends State<AturDataSiswaPage> {
  final _searchC = TextEditingController();
  Timer? _debounce;

  List<Siswa> _data = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchC.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ApiService.getSiswa(search: _searchC.text);
      if (!mounted) return;
      setState(() => _data = data);
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException && e.isUnauthorized) {
        handleApiError(context, e);
        return;
      }
      setState(() => _error = e is ApiException ? e.message : '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _load);
  }

  Future<void> _openForm([Siswa? siswa]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FormSiswaPage(siswa: siswa)),
    );
    if (saved == true && mounted) {
      showSnack(context, siswa == null
          ? 'Data siswa berhasil ditambahkan'
          : 'Data siswa berhasil diperbarui');
      _load();
    }
  }

  Future<void> _confirmDelete(Siswa siswa) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus data?'),
        content: Text('Data "${siswa.namaLengkap}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yes != true) return;

    try {
      await ApiService.deleteSiswa(siswa.id!);
      if (!mounted) return;
      showSnack(context, 'Data siswa berhasil dihapus');
      _load();
    } catch (e) {
      handleApiError(context, e);
    }
  }

  Widget _body() {
    if (_loading && _data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _load,
        child: MessageView(
          icon: Icons.cloud_off,
          message: _error!,
          actionLabel: 'Coba lagi',
          onAction: _load,
        ),
      );
    }
    if (_data.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: const MessageView(
          icon: Icons.search_off,
          message: 'Belum ada data siswa',
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
        itemCount: _data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final s = _data[i];
          return SiswaCard(
            siswa: s,
            onTap: () => showSiswaDetail(context, s),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Ubah',
                  icon: const Icon(Icons.edit_outlined, color: kPrimary),
                  onPressed: () => _openForm(s),
                ),
                IconButton(
                  tooltip: 'Hapus',
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                  onPressed: () => _confirmDelete(s),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimary),
        title: const Text(
          'Atur Data Siswa',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kPrimary,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Siswa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchC,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama, NIPD, atau alamat',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(child: _body()),
        ],
      ),
    );
  }
}
