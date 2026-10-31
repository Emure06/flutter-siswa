# API Siswa Flutter

REST API (Express + MySQL) untuk aplikasi Biodata Siswa.

## Setup

1. Import `db_siswa_flutter.sql` ke MySQL (lewat HeidiSQL).
2. Salin env: `cp .env.example .env`, lalu isi `DB_PASSWORD` dan `JWT_SECRET`.
3. Install dan jalankan:
   ```bash
   npm install
   npm run dev      # mode development (auto restart)
   npm start        # mode biasa
   ```
4. Tes: buka http://localhost:3000/api/health

## Endpoint

Semua response berbentuk `{ "success": true/false, "message": "...", "data": ... }`.

| Method | Endpoint | Auth | Keterangan |
|---|---|---|---|
| GET | `/api/health` | - | Cek API hidup |
| POST | `/api/auth/login` | - | Body: `username` (atau `email`) + `password` |
| POST | `/api/auth/register` | - | Body: `username`, `email`, `password` |
| GET | `/api/auth/me` | Bearer | Profil user login |
| GET | `/api/siswa` | Bearer | Daftar siswa + pencarian + pagination |
| GET | `/api/siswa/stats` | Bearer | Jumlah siswa per kelas/jurusan/gender |
| GET | `/api/siswa/:id` | Bearer | Detail siswa |
| POST | `/api/siswa` | Bearer | Tambah siswa |
| PUT | `/api/siswa/:id` | Bearer | Ganti semua field |
| PATCH | `/api/siswa/:id` | Bearer | Ubah sebagian field |
| DELETE | `/api/siswa/:id` | Bearer | Hapus siswa |

Query untuk `GET /api/siswa`: `page`, `limit` (maks 100), `search`, `kelas`, `jurusan`,
`jenis_kelamin`, `sort_by` (id/nama_lengkap/kelas/jurusan/nipd), `order` (asc/desc).

Token dikirim lewat header: `Authorization: Bearer <token>`.

## Menyambung dari Flutter

- **Emulator Android:** pakai `http://10.0.2.2:3000/api` (bukan localhost).
- **HP asli (satu WiFi/LAN):** pakai IP laptop, misalnya `http://192.168.1.10:3000/api`.
  Izinkan port 3000 di Windows Firewall.
- Karena memakai `http` (bukan https), tambahkan di `android/app/src/main/AndroidManifest.xml`
  pada tag `<application>`: `android:usesCleartextTraffic="true"`.
- Tambahkan package: `flutter pub add http`.

## Catatan keamanan

- Password lama yang masih plaintext (misalnya `123456` milik admin) tetap bisa login,
  dan otomatis di-hash bcrypt saat login berhasil pertama kali.
- Endpoint register terbuka. Kalau tidak mau sembarang orang mendaftar, hapus route-nya
  di `src/routes/authRoutes.js`.
- Jangan commit file `.env`.
