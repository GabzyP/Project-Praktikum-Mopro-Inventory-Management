import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product_model.dart';

class TambahProdukPage extends StatefulWidget {
  final Product? product;
  const TambahProdukPage({super.key, this.product});

  @override
  State<TambahProdukPage> createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<TambahProdukPage> {
  final namaController = TextEditingController();
  final skuController = TextEditingController();
  final stokController = TextEditingController(text: "0");
  final minStokController = TextEditingController(text: "5");

  String selectedCategory = "Umum";
  final List<String> categories = [
    "Elektronik",
    "Aksesoris",
    "Pakaian",
    "Makanan",
    "Umum",
  ];

  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      isEditMode = true;
      namaController.text = widget.product!.name;
      skuController.text = widget.product!.sku;
      stokController.text = widget.product!.stock.toString();
      if (categories.contains(widget.product!.category)) {
        selectedCategory = widget.product!.category;
      } else {
        selectedCategory = "Umum";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
        title: Text(
          isEditMode ? "Edit Barang" : "Tambah Barang Baru",
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nama Produk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            textField(namaController, "Masukkan nama produk"),

            const SizedBox(height: 20),

            const Text("SKU", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            textField(skuController, "Masukkan SKU", readOnly: isEditMode),

            const SizedBox(height: 20),

            const Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  dropdownColor: theme.cardColor,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Stok Awal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      textField(stokController, "0", isNumber: true),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Min. Stok Alert",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      textField(minStokController, "5", isNumber: true),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : _simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isEditMode ? "Update Produk" : "Simpan Produk",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpanData() async {
    if (namaController.text.isEmpty || skuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan SKU wajib diisi!")),
      );
      return;
    }
    setState(() => isLoading = true);
    Product productData = Product(
      id: isEditMode ? widget.product!.id : 0,
      name: namaController.text,
      sku: skuController.text,
      category: selectedCategory,
      stock: int.tryParse(stokController.text) ?? 0,
      price: 0,
    );
    bool success;
    if (isEditMode) {
      success = await apiService.updateProduct(productData);
    } else {
      success = await apiService.addProduct(productData);
    }
    setState(() => isLoading = false);
    if (success) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode ? "Berhasil diupdate!" : "Berhasil disimpan!",
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan. Cek SKU.")),
        );
      }
    }
  }

  Widget textField(
    TextEditingController c,
    String hint, {
    bool isNumber = false,
    bool readOnly = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: c,
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey),
        filled: true,
        fillColor: readOnly
            ? (isDark ? Colors.grey[800] : Colors.grey.shade200)
            : theme.cardColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
