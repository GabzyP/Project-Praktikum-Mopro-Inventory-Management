import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.165.55.179/inventory_api';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/get_products.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  Future<bool> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_product.php'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'name': product.name,
        'sku': product.sku,
        'category': product.category,
        'stock': product.stock,
        'price': product.price,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['success'];
    }
    return false;
  }

  Future<bool> updateProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update_product.php'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['success'];
    }
    return false;
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_product.php'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['success'];
    }
    return false;
  }
}
