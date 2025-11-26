class Product {
  final int id;
  final String name;
  final String sku;
  final String category;
  final int stock;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.stock,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      sku: json['sku'],
      category: json['category'] ?? 'Uncategorized',
      stock: int.parse(json['stock'].toString()),
      price: double.parse(json['price'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'category': category,
      'stock': stock,
      'price': price,
    };
  }
}
