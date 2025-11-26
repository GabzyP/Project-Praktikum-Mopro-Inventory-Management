import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/product_model.dart';
import '../../models/transaksi_model.dart';
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
  List<TransaksiModel> _allTransactions = [];

  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => isLoading = true);
    try {
      final products = await apiService.getProducts();
      final transactions = await apiService.getTransactions();

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _allTransactions = transactions;
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
    int totalProduk = _allProducts.length;
    int stokRendah = _allProducts.where((p) => p.stock < 5).length;

    int totalStokMasuk = _allTransactions
        .where((t) => t.type == 'IN')
        .fold(0, (sum, item) => sum + item.amount);

    int totalStokKeluar = _allTransactions
        .where((t) => t.type == 'OUT')
        .fold(0, (sum, item) => sum + item.amount);

    double screenWidth = MediaQuery.of(context).size.width;
    int gridCount = screenWidth < 800 ? 2 : 4;
    double childAspect = screenWidth < 600 ? 1.4 : 1.2;

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
              Navigator.pushNamed(context, '/notifikasi');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/profil');
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _loadData(),
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

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: gridCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspect,
                      children: [
                        _HoverCard(
                          title: "Total Produk",
                          value: "$totalProduk",
                          icon: Icons.inventory_2_outlined,
                          color: const Color(0xFF3B82F6),
                        ),
                        _HoverCard(
                          title: "Stok Masuk",
                          value: "$totalStokMasuk",
                          icon: Icons.trending_up,
                          color: const Color(0xFF10B981),
                        ),
                        _HoverCard(
                          title: "Stok Keluar",
                          value: "$totalStokKeluar",
                          icon: Icons.trending_down,
                          color: const Color(0xFF2563EB),
                        ),
                        _HoverCard(
                          title: "Stok Rendah",
                          value: "$stokRendah",
                          icon: Icons.warning_amber_rounded,
                          color: const Color(0xFFF59E0B),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/tambah-produk',
                          );
                          if (result == true) _loadData();
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "Tambah Barang Baru",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            "Stok Masuk",
                            Icons.arrow_downward,
                            () async {
                              await Navigator.pushNamed(context, '/stok-masuk');
                              _loadData();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            "Stok Keluar",
                            Icons.arrow_upward,
                            () async {
                              await Navigator.pushNamed(
                                context,
                                '/stok-keluar',
                              );
                              _loadData();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
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
                          return _ProductItem(
                            item: _filteredProducts[index],
                            onEdit: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => TambahProdukPage(
                                    product: _filteredProducts[index],
                                  ),
                                ),
                              );
                              if (result == true) _loadData();
                            },
                            onDelete: () async {
                              await apiService.deleteProduct(
                                _filteredProducts[index].id,
                              );
                              _loadData();
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _HoverCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovering
            ? (Matrix4.identity()..scale(1.03))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.4),
              blurRadius: _isHovering ? 12 : 8,
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
                  widget.title,
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
                  child: Icon(widget.icon, color: Colors.white, size: 18),
                ),
              ],
            ),
            Text(
              widget.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xffeef2f6),
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
}

class _ProductItem extends StatelessWidget {
  final Product item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ProductItem({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool isLowStock = item.stock < 5;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isLowStock
            ? Border.all(color: Colors.orange.shade200)
            : Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.inventory_2, color: Colors.blue),
          ),
          const SizedBox(width: 12),
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
                Text(
                  "SKU: ${item.sku}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      "${item.stock} Unit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isLowStock ? Colors.red : Colors.green,
                        fontSize: 13,
                      ),
                    ),
                    if (isLowStock) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          border: Border.all(color: const Color(0xFFFDBA74)),
                          borderRadius: BorderRadius.circular(4),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  InkWell(
                    onTap: onEdit,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: onDelete,
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
