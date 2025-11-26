class TransaksiModel {
  final String tipe;
  final String nama;
  final int jumlah;
  final String catatan;
  final DateTime waktu;

  TransaksiModel({
    required this.tipe,
    required this.nama,
    required this.jumlah,
    required this.catatan,
    required this.waktu,
  });
}
