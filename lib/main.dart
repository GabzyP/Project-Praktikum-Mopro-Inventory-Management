import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/dashboard/dashboard_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/produk/tambah_produk_page.dart';
import 'pages/stok/stok_masuk_page.dart';
import 'pages/stok/stok_keluar_page.dart';
import 'pages/laporan/laporan_page.dart';
import 'pages/other/notification_page.dart';
import 'pages/other/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff5f6fa),
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/tambah-produk': (context) => const TambahProdukPage(),
        '/stok-masuk': (context) => const StokMasukPage(),
        '/stok-keluar': (context) => const StokKeluarPage(),
        '/laporan': (context) => LaporanPage(),
        '/notifikasi': (context) => const NotificationPage(),
        '/profil': (context) => const ProfilePage(),
      },
    );
  }
}
