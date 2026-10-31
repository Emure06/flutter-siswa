import 'package:flutter/material.dart';

import '../models/siswa.dart';
import '../services/api_service.dart';
import '../utils/ui_helper.dart';

class FormSiswaPage extends StatefulWidget {
  final Siswa? siswa;

  const FormSiswaPage({super.key, this.siswa});

  @override
  State<FormSiswaPage> createState() => _FormSiswaPageState();
}

class _FormSiswaPageState extends State<FormSiswaPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaC;
  late final TextEditingController _nipdC;
  late final TextEditingController _kelasC;
  late final TextEditingController _jurusanC;
  late final TextEditingController _alamatC;
  String? _gender;
  bool _saving = false;

  bool get _isEdit => widget.siswa != null;

  @override
  void initState() {
    super.initState();
    final s = widget.siswa;
    _namaC = TextEditingController(text: s?.namaLengkap ?? '');
    _nipdC = TextEditingController(text: s?.nipd ?? '');
    _kelasC = TextEditingController(text: s?.kelas ?? '');
    _jurusanC = TextEditingController(text: s?.jurusan ?? '');
    _alamatC = TextEditingController(text: s?.alamat ?? '');
    _gender = s?.jenisKelamin;
  }

  @override
  void dispose() {
    _namaC.dispose();
    _nipdC.dispose();
    _kelasC.dispose();
    _jurusanC.dispose();
    _alamatC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final siswa = Siswa(
      id: widget.siswa?.id,
      namaLengkap: _namaC.text.trim(),
      jenisKelamin: _gender!,
      alamat: _alamatC.text.trim(),
      kelas: _kelasC.text.trim(),
      jurusan: _jurusanC.text.trim(),
      nipd: _nipdC.text.trim(),
    );

    setState(() => _saving = true);
    try {
      if (_isEdit) {
        await ApiService.updateSiswa(siswa);
      } else {
        await ApiService.createSiswa(siswa);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      handleApiError(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _dec(String label, {IconData? icon}) => InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      );

  String? _wajib(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimary),
        title: Text(
          _isEdit ? 'Ubah Data Siswa' : 'Tambah Data Siswa',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _namaC,
                  textCapitalization: TextCapitalization.words,
                  decoration: _dec('Nama lengkap', icon: Icons.person_outline),
                  validator: (v) => _wajib(v, 'Nama lengkap'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nipdC,
                  keyboardType: TextInputType.number,
                  decoration: _dec('NIPD (opsional)', icon: Icons.badge_outlined),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: _dec('Jenis kelamin', icon: Icons.wc_outlined),
                  items: const [
                    DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                  ],
                  onChanged: (v) => setState(() => _gender = v),
                  validator: (v) => v == null ? 'Pilih jenis kelamin' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _kelasC,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _dec('Kelas', icon: Icons.class_outlined),
                        validator: (v) => _wajib(v, 'Kelas'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _jurusanC,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _dec('Jurusan', icon: Icons.school_outlined),
                        validator: (v) => _wajib(v, 'Jurusan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _alamatC,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _dec('Alamat', icon: Icons.home_outlined),
                  validator: (v) => _wajib(v, 'Alamat'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(_isEdit ? 'Simpan Perubahan' : 'Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
