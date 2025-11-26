import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product_model.dart';
import '../produk/tambah_produk_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService apiService = ApiService();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() async {
    setState(() => isLoading = true);
    try {
      List<Product> products = await apiService.getProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _runFilter(String keyword) {
    List<Product> results = [];
    if (keyword.isEmpty) {
      results = _allProducts;
    } else {
      results = _allProducts
          .where(
            (item) =>
                item.name.toLowerCase().contains(keyword.toLowerCase()) ||
                item.sku.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      _filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // LOGIC HITUNG DUMMY (Bisa diganti API real nanti)
    int totalProduk = _allProducts.length;
    int stokRendah = _allProducts.where((p) => p.stock < 5).length;
    int stokMasuk = 0; // Dummy karena belum ada tabel transaksi
    int stokKeluar = 0; // Dummy

    // Responsive Grid
    double screenWidth = MediaQuery.of(context).size.width;
    int gridCount = screenWidth < 800 ? 2 : 4; // Tablet/Desktop 4 kolom
    double childAspect = screenWidth < 600 ? 1.4 : 1.2; // Rasio kartu

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fd),
      appBar: AppBar(
        title: const Text(
          "Inventori Barang",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tidak ada notifikasi baru")),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _refreshProducts(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Ringkasan inventori hari ini",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // --- GRID KARTU DASHBOARD (PERSIS DESAIN) ---
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: gridCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspect,
                      children: [
                        summaryCard(
                          "Total Produk",
                          "$totalProduk",
                          Icons.inventory_2_outlined,
                          const Color(0xFF3B82F6),
                        ),
                        summaryCard(
                          "Stok Masuk",
                          "$stokMasuk",
                          Icons.trending_up,
                          const Color(0xFF10B981),
                        ),
                        summaryCard(
                          "Stok Keluar",
                          "$stokKeluar",
                          Icons.trending_down,
                          const Color(0xFF2563EB),
                        ),
                        summaryCard(
                          "Stok Rendah",
                          "$stokRendah",
                          Icons.warning_amber_rounded,
                          const Color(0xFFF59E0B),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- TOMBOL MENU AKSI (BESAR & KECIL) ---
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Tombol Tambah lebih lebar
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/tambah-produk',
                                );
                                if (result == true) _refreshProducts();
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                "Tambah Barang",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: actionButton(
                            "Stok Masuk",
                            Icons.arrow_downward,
                            () => Navigator.pushNamed(context, '/stok-masuk'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: actionButton(
                            "Stok Keluar",
                            Icons.arrow_upward,
                            () => Navigator.pushNamed(context, '/stok-keluar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: actionButton(
                            "Laporan",
                            Icons.description_outlined,
                            () => Navigator.pushNamed(context, '/laporan'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "Produk Terkini",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- SEARCH BAR ---
                    TextField(
                      controller: searchController,
                      onChanged: _runFilter,
                      decoration: InputDecoration(
                        hintText: "Cari produk atau SKU...",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- LIST PRODUK ---
                    if (_filteredProducts.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text(
                              "Tidak ditemukan",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredProducts.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return productItem(context, _filteredProducts[index]);
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  // WIDGET KARTU UTAMA
  Widget summaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TOMBOL MENU KECIL
  Widget actionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xffeef2f6), // Abu kebiruan
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET ITEM LIST PRODUK
  Widget productItem(BuildContext context, Product item) {
    bool isLowStock = item.stock < 5;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align top
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffeef2ff),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 16),

          // Info Produk (Nama & SKU & Stok)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "SKU: ${item.sku}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 8), // Jarak ke Stok
                // Stok & Alert pindah ke bawah sini
                Row(
                  children: [
                    Text(
                      "${item.stock} unit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isLowStock
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF10B981), // Warna orange/hijau
                        fontSize: 13,
                      ),
                    ),
                    if (isLowStock) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED), // Orange muda banget
                          border: Border.all(color: const Color(0xFFFDBA74)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Stok Rendah",
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFC2410C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Bagian Kanan (Kategori & Edit/Hapus)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20), // Chip bulat
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => TambahProdukPage(product: item),
                        ),
                      );
                      if (result == true) _refreshProducts();
                    },
                    child: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
                      await apiService.deleteProduct(item.id);
                      _refreshProducts();
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
