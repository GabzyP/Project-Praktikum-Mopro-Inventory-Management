import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;

  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      isEditMode = true;
      nameController.text = widget.product!.name;
      skuController.text = widget.product!.sku;
      stockController.text = widget.product!.stock.toString();
      priceController.text = widget.product!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Barang" : "Tambah Barang Baru"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Barang",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: skuController,
                decoration: const InputDecoration(
                  labelText: "SKU",
                  border: OutlineInputBorder(),
                ),
                readOnly: isEditMode,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);

                          Product productData = Product(
                            id: isEditMode ? widget.product!.id : 0,
                            name: nameController.text,
                            sku: skuController.text,
                            category: "General",
                            stock: int.tryParse(stockController.text) ?? 0,
                            price: double.tryParse(priceController.text) ?? 0.0,
                          );

                          bool success;
                          if (isEditMode) {
                            success = await apiService.updateProduct(
                              productData,
                            );
                          } else {
                            success = await apiService.addProduct(productData);
                          }

                          setState(() => isLoading = false);

                          if (success) {
                            if (context.mounted) {
                              Navigator.pop(context, true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isEditMode
                                        ? "Data diperbarui!"
                                        : "Data ditambahkan!",
                                  ),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Gagal menyimpan data"),
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditMode ? "UPDATE DATA" : "SIMPAN DATA"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
