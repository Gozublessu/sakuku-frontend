class RestockRequest {
  final int jumlahProduk;
  final double hargaJual;
  final double hargaBeli;

  RestockRequest({
    required this.jumlahProduk,
    required this.hargaJual,
    required this.hargaBeli,
  });

  Map<String, dynamic> toJson() {
    return {
      "Jumlah_produk": jumlahProduk,
      "Harga_jual": hargaJual,
      "Harga_beli": hargaBeli,
    };
  }
}
