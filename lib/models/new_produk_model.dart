class NewProdukModel {
  final String namaProduk;
  final int qty;
  final DateTime dateIN;
  final String jenis;
  final num cost;

  NewProdukModel({
    required this.namaProduk,
    required this.qty,
    required this.dateIN,
    required this.jenis,
    required this.cost,
  });

  factory NewProdukModel.fromJson(Map<String, dynamic> json) {
    return NewProdukModel(
      namaProduk: json['nama_produk'] as String,
      qty: json['qty'] as int,
      jenis: json['jenis'] as String,
      dateIN: DateTime.parse(json['date_in']),
      cost: json['cost_product'],
    );
  }
}
