import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/transaksi_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.8/inventory_api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'success': false, 'message': 'Error koneksi: $e'};
    }
    return {'success': false, 'message': 'Koneksi gagal'};
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'success': false, 'message': 'Error koneksi: $e'};
    }
    return {'success': false, 'message': 'Koneksi gagal'};
  }

  Future<List<Product>> getProducts() async {
    try {
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
    } catch (e) {
      print("Error getProducts: $e");
      return [];
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
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
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
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
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
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
    } catch (e) {
      return false;
    }
  }

  Future<bool> addTransaction(
    int productId,
    String type,
    int amount,
    String notes,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_transaction.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'product_id': productId,
          'type': type,
          'amount': amount,
          'notes': notes,
        }),
      );
      return response.statusCode == 200 &&
          json.decode(response.body)['success'];
    } catch (e) {
      print("Error addTransaction: $e");
      return false;
    }
  }

  Future<List<TransaksiModel>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_transactions.php'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          List data = jsonResponse['data'];
          return data.map((item) => TransaksiModel.fromJson(item)).toList();
        }
      }
    } catch (e) {
      print("Error getTransactions: $e");
    }
    return [];
  }
}
