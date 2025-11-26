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
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        title: const Text("Stok Masuk", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
              decoration: _textFieldStyle("0"),
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
                        "Simpan Stok",
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih produk dulu!")));
      return;
    }

    int jumlah = int.tryParse(jumlahController.text) ?? 0;
    if (jumlah <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah harus lebih dari 0")),
      );
      return;
    }

    setState(() => isSaving = true);

    Product updatedProduct = Product(
      id: selectedProduct!.id,
      name: selectedProduct!.name,
      sku: selectedProduct!.sku,
      category: selectedProduct!.category,
      price: selectedProduct!.price,
      stock: selectedProduct!.stock + jumlah,
    );

    bool success = await apiService.updateProduct(updatedProduct);

    setState(() => isSaving = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Stok ${selectedProduct!.name} bertambah jadi ${updatedProduct.stock}!",
            ),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal update stok")));
    }
  }

  InputDecoration _textFieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
