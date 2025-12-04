# 🚀 Flutter Praktikum Mobile Programming

Repositori ini berisi kumpulan proyek Flutter yang dibuat oleh kelompok 1 sebagai proyek praktikum mobile programming, yaitu membuat aplikasi **Inventory Management** dengan Flutter.

Anggota Kelompok 1 :

1. Gabriel Glenn Peter Pardede (241712041)
2. Adeptri Sagala
3. William Tanu Wijaya
4. Kabul Manik

## 📂 Struktur Repositori

```text
inventory_api/      
lib/
├── models/
   ├── product_model.dart
   ├── transaksi_model.dart    
├── pages/
   ├── auth
      ├── login_page.dart
      ├── register_page.dart
   ├── dashboard
      ├── dashboard_page.dart
   ├── laporan
      ├── laporan_page.dart
   ├── other
      ├── notification_page.dart
      ├── profile_page.dart
   ├── produk
      ├── tambah_produk_page.dart
   ├── stok
      ├── stok_keluar_page.dart
      ├── stok_masuk_page.dart      
├── services/
   ├── api_service.dart    
├── utils/
   ├── theme_config.dart     
├── main.dart
├── db_inventory.sql   
└── pubspec.yaml  
```

## 🛠️ Persyaratan Sistem

- Flutter SDK (versi terbaru direkomendasikan)
- Dart SDK (versi 3.0.0 atau lebih tinggi)
- Android Studio atau VS Code dengan ekstensi Flutter
- Emulator atau perangkat fisik Android/iOS untuk pengujian
- Git (untuk mengelola versi kode)

## 🚀 Memulai

1. Pastikan Flutter sudah terinstall di sistem Anda. Jika belum, ikuti [panduan instalasi resmi](https://docs.flutter.dev/get-started/install).

2. Clone repositori ini:
   ```bash
   git clone https://github.com/GabzyP/Project-Praktikum-Mopro-Inventory-Management.git
   ```

3. Masuk ke direktori proyek:
   ```bash
   cd Project-Praktikum-Mopro-Inventory-Management
   ```

4. Masukkan folder inventory_api ke dalam xampp\htdocs
   
5. buat database di phpmyadmin dengan nama db_inventory lalu import file sql yang tersedia

6. ubah kode ------ baris ke 7 pada services\api_service.dart dengan IPv4 Address anda 
   ```bash
   static const String baseUrl = 'http://------/inventory_api';
   ```
   
8. Dapatkan dependencies yang dibutuhkan:
   ```bash
   flutter pub get
   ```
   
9. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 📚 Proyek Inventory Management

**Fitur Utama:**
-  Login & Register
-  Dashboard Statistik
-  Manajemen Stok (CRUD)
-  Peringatan Stok Rendah
-  Laporan Stok Keluar dan Masuk
-  Light and Dark Mode

**Demikian Proyek Kami Terima Kasih 😁**

