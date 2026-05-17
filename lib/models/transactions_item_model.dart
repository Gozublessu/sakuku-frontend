class TransactionItemModel {
  final int productId;
  final String namaProduk;
  final int qty;
  final double hargaJual;
  final double hargaModal;
  final double subtotalJual;
  final double subtotalModal;
  final double subtotalProfit;
  final bool isPromo;
  final String? promoType;

  TransactionItemModel({
    required this.productId,
    required this.qty,
    required this.hargaJual,
    required this.hargaModal,
    required this.subtotalJual,
    required this.subtotalModal,
    required this.subtotalProfit,
    required this.namaProduk,
    required this.isPromo,
    required this.promoType,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      namaProduk: json["Nama_produk"] ?? "",
      productId: json["product_id"],
      qty: json["qty"],
      hargaJual: (json["harga_jual"] as num).toDouble(),
      hargaModal: (json["harga_modal"] as num).toDouble(),
      subtotalJual: (json["subtotal_jual"] as num).toDouble(),
      subtotalModal: (json["subtotal_modal"] as num).toDouble(),
      subtotalProfit: (json["subtotal_profit"] as num).toDouble(),
      isPromo: json['is_promo'] ?? false,
      promoType: json['promo_type'],
    );
  }
}
