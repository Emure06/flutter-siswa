class Siswa {
  final int? id;
  final String namaLengkap;
  final String jenisKelamin;
  final String alamat;
  final String kelas;
  final String jurusan;
  final String? nipd;

  const Siswa({
    this.id,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.alamat,
    required this.kelas,
    required this.jurusan,
    this.nipd,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) => Siswa(
        id: json['id'] as int?,
        namaLengkap: json['nama_lengkap'] as String,
        jenisKelamin: json['jenis_kelamin'] as String,
        alamat: json['alamat'] as String,
        kelas: json['kelas'] as String,
        jurusan: json['jurusan'] as String,
        nipd: json['nipd'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'nama_lengkap': namaLengkap,
        'jenis_kelamin': jenisKelamin,
        'alamat': alamat,
        'kelas': kelas,
        'jurusan': jurusan,
        'nipd': (nipd == null || nipd!.trim().isEmpty) ? null : nipd!.trim(),
      };
}
