import 'dart:async';

import 'package:flutter/material.dart';

import '../models/siswa.dart';
import '../services/api_service.dart';
import '../utils/ui_helper.dart';
import '../widgets/siswa_widgets.dart';

/// Halaman LIHAT DATA: hanya untuk melihat, tidak ada edit/hapus.
class ViewUserPage extends StatefulWidget {
  const ViewUserPage({super.key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
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
          message: 'Data siswa tidak ditemukan',
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        itemCount: _data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => SiswaCard(
          siswa: _data[i],
          onTap: () => showSiswaDetail(context, _data[i]),
        ),
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
          'Lihat Data',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kPrimary,
          ),
        ),
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
