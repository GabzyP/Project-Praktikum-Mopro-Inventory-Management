class TransaksiModel {
  final int id;
  final int productId;
  final String productName;
  final String type;
  final int amount;
  final String notes;
  final DateTime createdAt;

  TransaksiModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.amount,
    required this.notes,
    required this.createdAt,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: int.parse(json['id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      productName: json['product_name'] ?? 'Unknown',
      type: json['type'],
      amount: int.parse(json['amount'].toString()),
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
