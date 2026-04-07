class tierListItem {
  final int productId;
  final String namaProduk;
  final int totalQty;
  final double totalJual;
  final double totalProfit;

  tierListItem({
    required this.productId,
    required this.namaProduk,
    required this.totalQty,
    required this.totalJual,
    required this.totalProfit,
  });

  factory tierListItem.fromJson(Map<String, dynamic> json) {
    return tierListItem(
      productId: json['product_id'],
      namaProduk: json['nama_produk'],
      totalQty: json['total_qty'],
      totalJual: (json['total_jual'] ?? 0).toDouble(),
      totalProfit: (json['total_profit'] ?? 0).toDouble(),
    );
  }
}
