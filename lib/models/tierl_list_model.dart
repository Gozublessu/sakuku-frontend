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

class TierListSummary {
  final int totalSkuSold;
  final int totalQtySold;

  TierListSummary({
    required this.totalSkuSold,
    required this.totalQtySold,
  });

  factory TierListSummary.fromJson(Map<String, dynamic> json) {
    return TierListSummary(
      totalSkuSold: json['total_sku_sold'] ?? 0,
      totalQtySold: json['total_qty_sold'] ?? 0,
    );
  }
}

class TierListResponse {
  final TierListSummary summary;
  final List<tierListItem> items;

  TierListResponse({
    required this.summary,
    required this.items,
  });

  factory TierListResponse.fromJson(Map<String, dynamic> json) {
    return TierListResponse(
      summary: TierListSummary.fromJson(json['summary']),
      items: (json['items'] as List).map((e) => tierListItem.fromJson(e)).toList(),
    );
  }
}
