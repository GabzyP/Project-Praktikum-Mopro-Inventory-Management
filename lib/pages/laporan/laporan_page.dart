import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../models/transaksi_model.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final ApiService apiService = ApiService();
  late Future<List<TransaksiModel>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = apiService.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Laporan Transaksi",
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
      ),
      body: FutureBuilder<List<TransaksiModel>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<TransaksiModel> transactions = snapshot.data ?? [];

          if (transactions.isEmpty) {
            return const Center(child: Text("Belum ada riwayat transaksi"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _buildTransaksiCard(transactions[index], theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildTransaksiCard(TransaksiModel t, ThemeData theme) {
    bool isMasuk = t.type == 'IN';
    bool isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: theme.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isMasuk
                        ? Colors.green.withOpacity(isDark ? 0.2 : 0.1)
                        : Colors.red.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isMasuk ? "Stok Masuk" : "Stok Keluar",
                    style: TextStyle(
                      color: isMasuk ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  DateFormat("d MMM yyyy, HH:mm", "id_ID").format(t.createdAt),
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.productName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  "${isMasuk ? '+' : '-'}${t.amount}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isMasuk ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            if (t.notes.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                "Catatan: ${t.notes}",
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
