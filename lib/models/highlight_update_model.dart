class HighlightUpdateModel {
  final int id;
  final String name;
  final bool type;
  final int qty;
  final DateTime createdAt;
  final num cost;

  HighlightUpdateModel({
    required this.id,
    required this.name,
    required this.type,
    required this.qty,
    required this.createdAt,
    required this.cost,
  });

  factory HighlightUpdateModel.fromJson(Map<String, dynamic> json) {
    return HighlightUpdateModel(
      id: json['id'] as int,
      name: json['Nama_produk'] as String,
      type: json['type'] as bool,
      qty: json['qty'] as int,
      createdAt: DateTime.parse(json['created_at']),
      cost: json['cost_product'],
    );
  }
}
