class DeadStockModel {
  final String nama;
  final int stock;
  final String jenis;
  final String netto;
  final String status;
  final DateTime? lastSold;
  final DateTime dateIn;

  DeadStockModel({
    required this.nama,
    required this.stock,
    required this.jenis,
    required this.status,
    required this.netto,
    this.lastSold,
    required this.dateIn,
  });

  bool get isNeverSold => lastSold == null;

  String get lastSoldText {
    if (lastSold == null) return "Belum terjual";

    final difference = DateTime.now().difference(lastSold!);

    return " Terakhir terjual ${difference.inDays} hari lalu";
  }

  factory DeadStockModel.fromJson(Map<String, dynamic> json) {
    return DeadStockModel(
      nama: json['nama_produk'] as String,
      stock: json['stok'] as int,
      jenis: json['jenis'] as String,
      netto: json['netto'] as String,
      status: json['status'] as String,
      lastSold: json['last'] != null ? DateTime.parse(json['last']) : null,
      dateIn: DateTime.parse(json['date_in']),
    );
  }
}
