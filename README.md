# belajar

Uji coba api yang mau di pakai

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



// READ MD YANG EMRE DAN HUGO



# Biodata Siswa

Aplikasi mobile untuk mengelola data siswa. Tampilannya dibuat dengan Flutter, datanya diambil lewat REST API (Node.js + Express) yang menyimpan semuanya di MySQL. Dua-duanya ada di repo ini: aplikasi Flutter di root project, API di folder `api/`.

Data yang disimpan untuk tiap siswa: id, NIPD, nama lengkap, jenis kelamin, alamat, kelas, dan jurusan.

## Isi

- [Fitur](#fitur)
- [Teknologi yang dipakai](#teknologi-yang-dipakai)
- [Struktur folder](#struktur-folder)
- [Yang perlu disiapkan](#yang-perlu-disiapkan)
- [Cara menjalankan](#cara-menjalankan)
- [Akun bawaan dan hak akses](#akun-bawaan-dan-hak-akses)
- [Cara kerja login dan token](#cara-kerja-login-dan-token)
- [Dokumentasi API](#dokumentasi-api)
- [Uji dengan Postman](#uji-dengan-postman)
- [Kalau ada masalah](#kalau-ada-masalah)
- [Catatan dan keterbatasan](#catatan-dan-keterbatasan)

## Fitur

Di sisi aplikasi:

- Login dan daftar akun. Setelah berhasil login, sesi disimpan di HP, jadi aplikasi langsung masuk ke dashboard saat dibuka lagi. Login baru diminta kalau pengguna menekan Logout.
- Lihat data siswa dengan kolom pencarian (nama, NIPD, atau alamat). Layar bisa ditarik ke bawah untuk memuat ulang, dan kalau satu siswa diketuk akan muncul detailnya.
- Atur data siswa: tambah, ubah, dan hapus. Menu ini hanya muncul untuk admin.
- Ada dua jenis akun, admin dan user biasa. User biasa hanya bisa melihat data.

Di sisi API:

- Login memakai JWT, password disimpan dalam bentuk hash (bcrypt).
- CRUD siswa lengkap, ditambah pencarian, filter, pengurutan, dan pagination.
- Endpoint statistik jumlah siswa per kelas, jurusan, dan jenis kelamin.
- Validasi input dengan pesan error berbahasa Indonesia.
- Pembatasan percobaan login (maksimal 20 kali per 15 menit untuk satu IP).

## Teknologi yang dipakai

| Bagian | Yang dipakai |
|---|---|
| Aplikasi | Flutter (Dart), package `http` dan `shared_preferences` |
| API | Node.js 18 ke atas, Express 4 |
| Library API | mysql2, jsonwebtoken, bcryptjs, zod, helmet, cors, morgan, express-rate-limit, dotenv |
| Database | MySQL 8 (dump dibuat dengan HeidiSQL dari MySQL 8.4.3) |
| Uji API | Postman |

## Struktur folder

```
.
├── lib/                          kode aplikasi Flutter
│   ├── main.dart                 titik awal, daftar route, cek sesi login
│   ├── config/
│   │   └── api_config.dart       alamat server API
│   ├── models/
│   │   ├── siswa.dart            model data siswa
│   │   └── User.dart             sisa awal, sudah tidak dipakai
│   ├── services/
│   │   └── api_service.dart      semua pemanggilan API dan penyimpanan token
│   ├── utils/
│   │   └── ui_helper.dart        warna, snackbar, penanganan error
│   ├── widgets/
│   │   └── siswa_widgets.dart    kartu siswa, detail siswa, tampilan kosong/error
│   └── pages/
│       ├── page_login.dart
│       ├── page_register.dart
│       ├── dashboard.dart
│       ├── page_view_user.dart       lihat data (hanya baca)
│       ├── page_atur_data_siswa.dart daftar + tombol ubah/hapus/tambah
│       └── page_form_siswa.dart      form tambah dan ubah
│
├── api/                          server REST API
│   ├── src/
│   │   ├── server.js             menyalakan server dan cek koneksi database
│   │   ├── app.js                middleware dan pemasangan route
│   │   ├── config/db.js          koneksi MySQL
│   │   ├── routes/               authRoutes.js, siswaRoutes.js
│   │   ├── controllers/          authController.js, siswaController.js
│   │   ├── middleware/           auth.js, requireAdmin.js, validate.js, errorHandler.js
│   │   └── utils/                AppError.js, asyncHandler.js
│   ├── db/add_role.sql           tambahan kolom role untuk tabel user
│   ├── .env.example
│   ├── requests.http             contoh request untuk extension REST Client
│   └── package.json
│
├── pubspec.yaml
└── README.md
```

## Yang perlu disiapkan

- Flutter SDK dan satu perangkat untuk menjalankan aplikasi (emulator Android, HP asli, atau Chrome)
- Node.js versi 18 atau lebih baru
- MySQL 8, bisa lewat XAMPP atau service MySQL biasa
- HeidiSQL atau tool sejenis untuk mengimpor file SQL
- Postman, kalau mau menguji API

## Cara menjalankan

Urutannya penting: database dulu, lalu API, baru aplikasi.

### 1. Database

Impor file dump `db_siswa_flutter.sql` lewat HeidiSQL (menu File, Run SQL file). Ini akan membuat database `db_siswa_flutter` beserta tabel `siswa` dan `user`, lengkap dengan beberapa data contoh.

Setelah itu, jalankan isi `api/db/add_role.sql` satu kali di tab Query. Script ini menambah kolom `role` di tabel `user` dan menjadikan akun `admin` sebagai admin. Kolom ini tidak ada di dump aslinya, jadi tanpa langkah ini login dan pembatasan akses tidak akan berjalan. Kalau dijalankan dua kali, MySQL akan menolak dengan pesan duplicate column, itu tidak berbahaya.

### 2. API

Dari root project:

```bash
cd api
copy .env.example .env
npm install
```

Pakai `cp` kalau terminalnya Git Bash atau Linux/macOS, `copy` untuk CMD atau PowerShell di Windows.

Buka file `.env` lalu sesuaikan:

| Variabel | Fungsi | Contoh |
|---|---|---|
| `PORT` | port server | `3000` |
| `DB_HOST` | alamat MySQL | `127.0.0.1` |
| `DB_PORT` | port MySQL | `3306` |
| `DB_USER` | user MySQL | `root` |
| `DB_PASSWORD` | password MySQL, kosongkan kalau tidak ada | |
| `DB_NAME` | nama database | `db_siswa_flutter` |
| `JWT_SECRET` | kunci untuk membuat dan memeriksa token, isi string acak yang panjang | |
| `JWT_EXPIRES_IN` | masa berlaku token | `7d` |
| `CORS_ORIGIN` | origin yang boleh mengakses, `*` berarti semua | `*` |

Lalu jalankan:

```bash
npm run dev
```

Kalau berhasil, terminal menampilkan `Terhubung ke database MySQL` dan `Server jalan di http://localhost:3000`. Buka `http://localhost:3000/api/health` di browser untuk memastikan, harusnya muncul `"success": true`.

`npm run dev` memakai fitur watch bawaan Node, jadi server restart sendiri tiap ada file API yang diubah. Kalau yang diubah file `.env`, hentikan dulu dengan Ctrl+C lalu jalankan lagi.

Mengakses `http://localhost:3000/` tanpa `/api` memang menghasilkan "Endpoint GET / tidak ditemukan". Semua endpoint ada di bawah `/api`.

### 3. Aplikasi Flutter

Buka terminal kedua (jangan matikan terminal API), pastikan posisinya di root project, bukan di folder `api`:

```bash
flutter pub get
flutter run
```

Jadi saat development ada dua terminal yang jalan bersamaan: satu untuk API, satu untuk Flutter. Kalau ada lebih dari satu perangkat, pilih dengan `flutter devices` lalu `flutter run -d <nama_perangkat>`.

Saat aplikasi sedang jalan, tekan `r` di terminal Flutter untuk hot reload dan `R` untuk hot restart. Setelah menambah package baru, aplikasi harus dihentikan dan dijalankan ulang, hot reload tidak cukup.

### 4. Alamat API sesuai perangkat

Alamat server diatur di `lib/config/api_config.dart`. Secara otomatis dipilih begini:

| Perangkat | Alamat yang dipakai |
|---|---|
| Emulator Android | `http://10.0.2.2:3000/api` |
| Chrome, Windows, iOS simulator | `http://localhost:3000/api` |

Alasan emulator Android memakai `10.0.2.2`: di dalam emulator, `localhost` menunjuk ke emulator itu sendiri, bukan ke laptop. Alamat `10.0.2.2` adalah jalan pintas emulator ke laptop.

Kalau memakai HP asli, HP dan laptop harus tersambung ke WiFi yang sama. Cari IP laptop dengan `ipconfig` (lihat IPv4 Address), lalu isi `manualBaseUrl` di file tadi, misalnya:

```dart
static const String manualBaseUrl = 'http://192.168.1.10:3000/api';
```

Port 3000 juga perlu diizinkan di Windows Firewall, kalau tidak HP akan kena timeout.

Untuk Android, buka `android/app/src/main/AndroidManifest.xml` dan pastikan dua hal ini ada. Izin internet ditaruh sebelum tag `<application>`, sedangkan `usesCleartextTraffic` di dalam tag `<application>`, karena API di sini masih memakai `http`, bukan `https`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>

<application
    android:usesCleartextTraffic="true"
    ... >
```

## Akun bawaan dan hak akses

Akun yang sudah ada di database:

| Username | Password | Role |
|---|---|---|
| admin | 123456 | admin |

Password `123456` itu awalnya tersimpan apa adanya di database. Begitu admin login pertama kali, API otomatis mengubahnya menjadi hash bcrypt. Sebaiknya password ini diganti sebelum aplikasi dipakai orang lain.

Orang yang mendaftar lewat tombol "Belum punya akun? Daftar" di halaman login otomatis berperan `user`. Tidak ada cara mendaftar sebagai admin dari aplikasi.

| | Admin | User biasa |
|---|---|---|
| Lihat data siswa | bisa | bisa |
| Cari dan lihat detail | bisa | bisa |
| Tambah, ubah, hapus | bisa | tidak bisa |
| Menu Atur Data Siswa | tampil | tidak tampil |

Pembatasan ini dijaga di dua tempat. Di aplikasi, menunya disembunyikan. Di API, setiap request tambah, ubah, dan hapus dicek lagi ke database, dan kalau bukan admin dijawab 403. Jadi percuma saja kalau ada yang mencoba memanggil API langsung tanpa lewat aplikasi.

Untuk menjadikan akun lain sebagai admin, ubah lewat SQL:

```sql
UPDATE `user` SET `role` = 'admin' WHERE `username` = 'nama_user';
```

Di API perubahannya langsung berlaku, tapi menu di aplikasi baru ikut berubah setelah orangnya logout dan login lagi.

## Cara kerja login dan token

Saat login, aplikasi mengirim username dan password ke `POST /api/auth/login`. Kalau cocok, API membalas dengan token JWT. Token itu berisi id, username, dan role pengguna, ditandatangani memakai `JWT_SECRET`, dan punya masa berlaku sesuai `JWT_EXPIRES_IN` (bawaannya 7 hari).

Di aplikasi, token disimpan lewat `shared_preferences` bersama data user. Tiap request ke API otomatis menyertakannya di header:

```
Authorization: Bearer <token>
```

Hal ini diatur di satu tempat saja, yaitu `lib/services/api_service.dart`, jadi halaman-halaman lain tidak perlu mengurus token sendiri.

Saat aplikasi dibuka, `main.dart` mengecek apakah ada token tersimpan. Kalau ada, langsung ke dashboard. Kalau tidak, ke halaman login. Tombol Logout menghapus token dari memori dan dari penyimpanan HP.

Kalau token sudah kedaluwarsa atau tidak valid, API menjawab 401. Aplikasi lalu menghapus sesi, kembali ke halaman login, dan menampilkan pesan "Sesi habis, silakan login ulang".

Dua hal yang perlu diingat. Pertama, kalau `JWT_SECRET` diganti, semua token lama langsung tidak berlaku dan semua orang harus login ulang. Kedua, mematikan atau me-restart server API tidak membuat token hilang, selama `JWT_SECRET` tidak berubah.

## Dokumentasi API

Alamat dasar: `http://localhost:3000/api`

Semua endpoint di bawah `/siswa` dan `/auth/me` butuh header `Authorization: Bearer <token>`. Body request dikirim sebagai JSON, jadi tambahkan juga `Content-Type: application/json`.

### Daftar endpoint

| Method | Endpoint | Perlu token | Siapa | Fungsi |
|---|---|---|---|---|
| GET | `/health` | tidak | semua | cek API hidup |
| POST | `/auth/login` | tidak | semua | login |
| POST | `/auth/register` | tidak | semua | buat akun (role user) |
| GET | `/auth/me` | ya | semua | data akun yang sedang login |
| GET | `/siswa` | ya | semua | daftar siswa |
| GET | `/siswa/stats` | ya | semua | jumlah siswa per kelas, jurusan, jenis kelamin |
| GET | `/siswa/:id` | ya | semua | detail satu siswa |
| POST | `/siswa` | ya | admin | tambah siswa |
| PUT | `/siswa/:id` | ya | admin | ubah semua field |
| PATCH | `/siswa/:id` | ya | admin | ubah sebagian field |
| DELETE | `/siswa/:id` | ya | admin | hapus siswa |

### Bentuk respons

Semua respons berbentuk JSON dengan pola yang sama. Kalau berhasil:

```json
{
  "success": true,
  "message": "...",
  "data": { }
}
```

Kalau gagal:

```json
{
  "success": false,
  "message": "Penjelasan singkat kenapa gagal"
}
```

Untuk error validasi, ada tambahan `errors` yang merinci field mana yang salah.

### Login

`POST /auth/login`

Body bisa berisi `username` atau `email`, ditambah `password`:

```json
{
  "username": "admin",
  "password": "123456"
}
```

Respons (200):

```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@gmail.com",
      "role": "admin"
    }
  }
}
```

Kalau username atau password salah, jawabannya 401 dengan pesan "Username/email atau password salah".

### Register

`POST /auth/register`

```json
{
  "username": "budi",
  "email": "budi@mail.com",
  "password": "rahasia123"
}
```

Username minimal 3 karakter dan hanya boleh berisi huruf, angka, titik, dan underscore. Password minimal 6 karakter. Kalau username atau email sudah dipakai, jawabannya 409. Respons sukses (201) sama bentuknya dengan login, jadi pengguna langsung punya token.

### Daftar siswa

`GET /siswa`

Semua parameter berikut opsional dan dipasang lewat query string, misalnya `/siswa?search=emre&kelas=XII&page=1&limit=10`.

| Parameter | Keterangan | Bawaan |
|---|---|---|
| `page` | nomor halaman | 1 |
| `limit` | jumlah data per halaman, maksimal 100 | 10 |
| `search` | cari di nama lengkap, NIPD, dan alamat | |
| `kelas` | filter kelas, harus persis sama | |
| `jurusan` | filter jurusan, harus persis sama | |
| `jenis_kelamin` | `Laki-laki` atau `Perempuan` | |
| `sort_by` | `id`, `nama_lengkap`, `kelas`, `jurusan`, atau `nipd` | `id` |
| `order` | `asc` atau `desc` | `asc` |

Contoh respons:

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nama_lengkap": "Emre",
      "jenis_kelamin": "Laki-laki",
      "alamat": "Kabasiran",
      "kelas": "XII",
      "jurusan": "RPL",
      "nipd": "242510057"
    },
    {
      "id": 2,
      "nama_lengkap": "Hugo",
      "jenis_kelamin": "Laki-laki",
      "alamat": "Griya",
      "kelas": "XII",
      "jurusan": "RPL",
      "nipd": "242510062"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 2,
    "total_pages": 1
  }
}
```

### Statistik

`GET /siswa/stats` mengembalikan total siswa, serta jumlah per kelas, per jurusan, dan per jenis kelamin.

### Detail siswa

`GET /siswa/1` mengembalikan satu objek siswa di dalam `data`. Kalau id tidak ada, jawabannya 404. Kalau id bukan angka, jawabannya 422.

### Tambah siswa

`POST /siswa` (admin)

```json
{
  "nipd": "242510099",
  "nama_lengkap": "Budi Santoso",
  "jenis_kelamin": "Laki-laki",
  "alamat": "Jl. Mawar No. 5",
  "kelas": "XII",
  "jurusan": "RPL"
}
```

Kalau berhasil, jawabannya 201 beserta data siswa yang baru dibuat (lengkap dengan id-nya).

Aturan tiap field:

| Field | Wajib | Aturan |
|---|---|---|
| `nama_lengkap` | ya | maksimal 100 karakter |
| `jenis_kelamin` | ya | hanya `Laki-laki` atau `Perempuan` |
| `alamat` | ya | teks bebas |
| `kelas` | ya | maksimal 20 karakter |
| `jurusan` | ya | maksimal 50 karakter |
| `nipd` | tidak | maksimal 50 karakter, tidak boleh sama dengan siswa lain |

### Ubah siswa

`PUT /siswa/:id` (admin) mengirim semua field seperti pada tambah siswa. `PATCH /siswa/:id` (admin) cukup mengirim field yang mau diubah saja, misalnya:

```json
{
  "alamat": "Jl. Melati No. 10"
}
```

Kalau body PATCH kosong, jawabannya 422. Kalau NIPD yang dikirim sudah dipakai siswa lain, jawabannya 409.

### Hapus siswa

`DELETE /siswa/:id` (admin). Data dihapus permanen, tidak ada tempat sampah. Kalau id tidak ada, jawabannya 404.

### Contoh error validasi

Kirim `POST /siswa` dengan body kosong, hasilnya 422:

```json
{
  "success": false,
  "message": "Validasi gagal",
  "errors": [
    { "field": "nama_lengkap", "message": "Nama lengkap wajib diisi" },
    { "field": "jenis_kelamin", "message": "Jenis kelamin harus 'Laki-laki' atau 'Perempuan'" }
  ]
}
```

(Daftar `errors` aslinya lebih panjang, satu entri untuk tiap field yang bermasalah.)

### Kode status

| Kode | Artinya |
|---|---|
| 200 | berhasil |
| 201 | berhasil membuat data baru |
| 400 | format JSON pada body rusak |
| 401 | token tidak ada, tidak valid, kedaluwarsa, atau login salah |
| 403 | token valid tapi bukan admin |
| 404 | data atau endpoint tidak ditemukan |
| 409 | data ganda (username, email, atau NIPD sudah dipakai) |
| 422 | isi request tidak lolos validasi |
| 429 | terlalu banyak percobaan login atau register |
| 500 | kesalahan di server, biasanya cek terminal API |

## Uji dengan Postman

Impor file `API-Siswa-Simple.postman_collection.json` lewat tombol Import di Postman. Isinya satu request Login dan satu folder Siswa:

```
API Siswa
├── Login
└── Siswa
    ├── getAll             GET     /siswa
    ├── getDataSiswabyid   GET     /siswa/1
    ├── POST               POST    /siswa
    ├── PUT                PUT     /siswa/1
    └── DELETE             DELETE  /siswa/3
```

Langkahnya:

1. Pastikan MySQL dan API sudah jalan.
2. Kirim request **Login**. Tokennya otomatis disimpan ke variabel collection `token`, jadi tidak perlu disalin manual.
3. Kirim request lain di folder **Siswa**.

Beberapa hal soal isi request-nya:

- POST memakai `{{$timestamp}}` sebagai NIPD supaya bisa dikirim berkali-kali tanpa kena error NIPD ganda.
- PUT mengirim data Emre persis seperti yang ada di database, jadi tidak mengubah apa-apa.
- DELETE menghapus siswa dengan id 3, yaitu id siswa pertama yang dibuat lewat POST. Kalau id hasil POST di databasemu berbeda, ganti angka di URL-nya, dan hati-hati supaya tidak menghapus id 1 atau 2.
- Alamat server ada di variabel collection `baseUrl`. Ganti di sana kalau port atau IP-nya berbeda.

Untuk melihat tokennya, klik nama collection, buka tab Variables, dan lihat kolom Current value di baris `token`. Isi token bisa dibaca di jwt.io untuk melihat username, role, dan waktu kedaluwarsanya.

Kalau lebih suka menguji dari VS Code, ada juga `api/requests.http` yang bisa dipakai dengan extension REST Client.

## Kalau ada masalah

| Gejala | Kemungkinan penyebab dan solusi |
|---|---|
| `npm` tidak dikenali | Node.js belum terpasang. Pasang versi LTS dari nodejs.org. |
| API berhenti dengan "JWT_SECRET belum diisi" | File `.env` belum dibuat atau `JWT_SECRET` masih kosong. |
| "Gagal konek ke database: Access denied" | `DB_USER` atau `DB_PASSWORD` di `.env` salah. |
| "Gagal konek ke database: ECONNREFUSED" | MySQL belum menyala. |
| "Unknown database" | File SQL belum diimpor. |
| Login selalu 500 atau error "Unknown column 'role'" | `api/db/add_role.sql` belum dijalankan. |
| "Endpoint GET / tidak ditemukan" di browser | Itu normal. Buka `/api/health`, bukan `/`. |
| Aplikasi bilang "Tidak bisa terhubung ke server" | API belum jalan, atau alamat di `api_config.dart` tidak cocok dengan perangkat (lihat bagian alamat API di atas). |
| Di HP asli selalu timeout | HP dan laptop beda jaringan, IP salah, atau port 3000 diblokir firewall. |
| Request dari HP ditolak padahal IP benar | Cek `usesCleartextTraffic` dan izin INTERNET di `AndroidManifest.xml`. |
| Muncul 401 padahal sudah login | Token kedaluwarsa atau `JWT_SECRET` pernah diganti. Logout lalu login lagi. |
| Menu Atur Data Siswa tidak muncul | Akun bukan admin, atau role baru diubah dan belum login ulang. |
| 403 saat tambah, ubah, atau hapus | Akun yang dipakai bukan admin. |
| 429 "Terlalu banyak percobaan" | Kena batas login. Tunggu sekitar 15 menit. |
| Setelah `flutter pub add` muncul error `MissingPluginException` | Aplikasi belum dijalankan ulang. Hentikan dengan `q` lalu `flutter run` lagi. |
| `ping github.com` gagal di jaringan LAN | Itu masalah jaringan, tidak ada hubungannya dengan project ini. Coba hotspot HP untuk `git pull` dan `git push`. |

## Catatan dan keterbatasan

Aplikasi ini dibuat untuk belajar, jadi ada beberapa hal yang sengaja dibuat sederhana dan perlu dibereskan kalau mau dipakai sungguhan.

- Token disimpan di `shared_preferences`, yang isinya tidak dienkripsi. Untuk pemakaian serius sebaiknya diganti ke `flutter_secure_storage`.
- Komunikasi masih lewat `http`, belum `https`. Karena itu `usesCleartextTraffic` dinyalakan. Jangan dipakai begini di server publik.
- Endpoint register terbuka untuk siapa saja yang bisa menjangkau API. Kalau pendaftaran mau dibatasi, hapus route register di `api/src/routes/authRoutes.js`.
- Belum ada fitur lupa password dan ganti password, dan belum ada refresh token. Kalau token habis, pengguna login ulang.
- Aplikasi mengambil maksimal 100 siswa sekali muat. Untuk data yang lebih banyak perlu ditambah pagination di sisi aplikasi (API-nya sudah mendukung).
- Hapus data bersifat permanen dan tidak bisa dibatalkan.
- File `.env` berisi password database dan kunci token, jadi jangan di-commit ke Git. Folder `api/` sudah punya `.gitignore` yang mengabaikannya, tapi tetap cek dengan `git status` sebelum commit.
- Folder `build/` dan `api/node_modules/` tidak perlu ikut dibagikan. Orang lain cukup menjalankan `flutter pub get` dan `npm install` sendiri.

## Pengembang

Nama: 
Kelas: 
Tahun:
