class ProdukModel {
  final String namaProduk;
  final String jenisProduk;
  final String netto;
  final int hargaBeli;
  final int jumlahProduk;
  final int hargaJual;
  final int id;
  final String kodeProduk;
  final int marginRupiah;
  final double marginPersen;
  final String movement;
  final String trend;
  int totalSold;

  ProdukModel({
    required this.namaProduk,
    required this.jenisProduk,
    required this.netto,
    required this.hargaBeli,
    required this.jumlahProduk,
    required this.hargaJual,
    required this.id,
    required this.kodeProduk,
    required this.marginRupiah,
    required this.marginPersen,
    this.totalSold = 0,
    required this.movement,
    required this.trend,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      namaProduk: json["Nama_produk"],
      jenisProduk: json["Jenis_produk"],
      netto: json["NETTO"],
      hargaBeli: json["Harga_beli"],
      jumlahProduk: json["Jumlah_produk"],
      hargaJual: json["Harga_jual"],
      id: json["id"],
      kodeProduk: json["Kode_produk"],
      marginRupiah: json["Margin_rupiah"],
      marginPersen: (json["Margin_persen"] as num).toDouble(),
      totalSold: int.tryParse(json["total_sold"]?.toString() ?? "0") ?? 0,
      movement: json["movement"] ?? '',
      trend: json["trend"] ?? '',
    );
  }
}

class SummaryItem {
  final String jenisProduk;
  final int total;

  SummaryItem({
    required this.jenisProduk,
    required this.total,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      jenisProduk: json['jenis_produk'],
      total: json['total'],
    );
  }
}

class PaginatedProduct {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasMore;
  final List<ProdukModel> data;
  // final Summary summary;

  PaginatedProduct({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasMore,
    required this.data,
    // required this.summary,
  });

  factory PaginatedProduct.fromJson(Map<String, dynamic> json) {
    return PaginatedProduct(
      page: json['page'],
      limit: json['limit'],
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      hasMore: json['has_more'],
      data: (json['data'] as List).map((e) => ProdukModel.fromJson(e)).toList(),
      // summary: Summary.fromJson(json['summary']),
    );
  }
}
