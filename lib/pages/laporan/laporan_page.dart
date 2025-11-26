import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaksi_model.dart';

class LaporanPage extends StatelessWidget {
  LaporanPage({super.key});

  final List<TransaksiModel> laporan = [
    TransaksiModel(
      tipe: "Keluar",
      nama: "pop mi",
      jumlah: 3,
      catatan: "ee",
      waktu: DateTime(2025, 11, 25, 20, 52),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text("Laporan Transaksi"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download, size: 18),
              label: const Text("Export"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: laporan.length,
        itemBuilder: (context, index) {
          final item = laporan[index];
          return _buildTransaksiCard(item);
        },
      ),
    );
  }

  Widget _buildTransaksiCard(TransaksiModel t) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
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
                    color: t.tipe == "Masuk"
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    t.tipe,
                    style: TextStyle(
                      color: t.tipe == "Masuk" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              t.nama,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "Jumlah: ${t.jumlah} unit",
              style: const TextStyle(color: Colors.black87),
            ),
            if (t.catatan.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                "Catatan: ${t.catatan}",
                style: const TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 4),
            Text(
              DateFormat("d MMMM yyyy 'pukul' HH.mm", "id_ID").format(t.waktu),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
