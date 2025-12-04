import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product_model.dart';

class StokMasukPage extends StatefulWidget {
  const StokMasukPage({super.key});

  @override
  State<StokMasukPage> createState() => _StokMasukPageState();
}

class _StokMasukPageState extends State<StokMasukPage> {
  final ApiService apiService = ApiService();

  Product? selectedProduct;
  List<Product> daftarProduk = [];
  bool isLoading = true;
  bool isSaving = false;

  final jumlahController = TextEditingController(text: "0");
  final catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    try {
      List<Product> products = await apiService.getProducts();
      setState(() {
        daftarProduk = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Stok Masuk",
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Produk",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Memuat produk..."),
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<Product>(
                        value: selectedProduct,
                        hint: Text(
                          "Pilih produk...",
                          style: TextStyle(
                            color: isDark ? Colors.grey : Colors.black54,
                          ),
                        ),
                        isExpanded: true,
                        dropdownColor: theme.cardColor,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        items: daftarProduk.map((Product item) {
                          return DropdownMenuItem<Product>(
                            value: item,
                            child: Text("${item.name} (Stok: ${item.stock})"),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => selectedProduct = value),
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Jumlah Masuk",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: _textFieldStyle("0", theme),
            ),

            const SizedBox(height: 20),

            const Text(
              "Catatan (Opsional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: catatanController,
              maxLines: 3,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: _textFieldStyle("Tambahkan catatan...", theme),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isSaving ? null : _simpanStokMasuk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan Stok Masuk",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpanStokMasuk() async {
    if (selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih produk terlebih dahulu")),
      );
      return;
    }

    int jumlahMasuk = int.tryParse(jumlahController.text) ?? 0;
    if (jumlahMasuk <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah harus lebih dari 0")),
      );
      return;
    }

    setState(() => isSaving = true);

    bool success = await apiService.addTransaction(
      selectedProduct!.id,
      'IN',
      jumlahMasuk,
      catatanController.text,
    );

    setState(() => isSaving = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Stok masuk berhasil!"),
            backgroundColor: Colors.blue,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan transaksi")),
        );
    }
  }

  InputDecoration _textFieldStyle(String hint, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.grey : Colors.black54),
      filled: true,
      fillColor: theme.cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
