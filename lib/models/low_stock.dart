class LowStockItem {
  final int id;
  final String name;
  final int stock;

  LowStockItem({
    required this.id,
    required this.name,
    required this.stock,
  });

  factory LowStockItem.fromJson(Map<String, dynamic> json) {
    return LowStockItem(
      id: json['id'] as int,
      name: json['name'] as String,
      stock: json['stock'] as int,
    );
  }
}

class LowStockResp {
  final int count;
  final List<LowStockItem> data;

  LowStockResp({
    required this.count,
    required this.data,
  });

  factory LowStockResp.fromJson(Map<String, dynamic> json) {
    return LowStockResp(
      count: json['count'] as int,
      data: (json['data'] as List).map((e) => LowStockItem.fromJson(e)).toList(),
    );
  }
}
