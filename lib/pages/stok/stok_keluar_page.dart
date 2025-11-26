import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product_model.dart';

class StokKeluarPage extends StatefulWidget {
  const StokKeluarPage({super.key});

  @override
  State<StokKeluarPage> createState() => _StokKeluarPageState();
}

class _StokKeluarPageState extends State<StokKeluarPage> {
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

  // Ambil data produk dari database
  void _fetchProducts() async {
    try {
      List<Product> products = await apiService.getProducts();
      setState(() {
        daftarProduk = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengambil data produk")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Stok Keluar", style: TextStyle(color: Colors.black)),
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

            // DROPDOWN PRODUK
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                        hint: const Text("Pilih produk..."),
                        isExpanded: true,
                        // Tampilkan Nama + Sisa Stok
                        items: daftarProduk.map((Product item) {
                          return DropdownMenuItem<Product>(
                            value: item,
                            child: Text(
                              "${item.name} (Sisa: ${item.stock})",
                              style: TextStyle(
                                color: item.stock == 0
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProduct = value;
                          });
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Jumlah Keluar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: _textFieldStyle("0"),
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
              decoration: _textFieldStyle("Tambahkan catatan..."),
            ),

            const SizedBox(height: 30),

            // TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isSaving ? null : _simpanStokKeluar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan Stok Keluar",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpanStokKeluar() async {
    if (selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih produk terlebih dahulu")),
      );
      return;
    }

    int jumlahKeluar = int.tryParse(jumlahController.text) ?? 0;

    // VALIDASI 1: Jumlah tidak boleh 0 atau minus
    if (jumlahKeluar <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah harus lebih dari 0")),
      );
      return;
    }

    // VALIDASI 2: Stok tidak boleh minus (PENTING!)
    if (jumlahKeluar > selectedProduct!.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Stok tidak cukup! Sisa hanya ${selectedProduct!.stock}",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    // LOGIC KURANGI STOK
    Product updatedProduct = Product(
      id: selectedProduct!.id,
      name: selectedProduct!.name,
      sku: selectedProduct!.sku,
      category: selectedProduct!.category,
      price: selectedProduct!.price,
      stock: selectedProduct!.stock - jumlahKeluar, // STOK LAMA - KELUAR
    );

    bool success = await apiService.updateProduct(updatedProduct);

    setState(() => isSaving = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Stok keluar berhasil. Sisa stok: ${updatedProduct.stock}",
            ),
            backgroundColor: Colors.blue,
          ),
        );
        Navigator.pop(context); // Kembali ke dashboard
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal mengupdate stok")));
      }
    }
  }

  InputDecoration _textFieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
