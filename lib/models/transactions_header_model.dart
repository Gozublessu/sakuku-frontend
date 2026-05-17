import 'package:sakuku_desktop/models/transactions_item_model.dart';

class TransactionHeaderModel {
  final int id;
  final String namaProduk;
  final String date;
  final double totalPenjualan;
  final double totalModal;
  final double totalProfit;
  final bool isPromo;
  final String? promoType;
  // final double jumlahTransaksi;
  final List<TransactionItemModel> items;

  TransactionHeaderModel({
    required this.id,
    required this.date,
    required this.totalPenjualan,
    required this.totalModal,
    required this.totalProfit,
    required this.items,
    required this.namaProduk,
    required this.isPromo,
    required this.promoType,
    // required this.jumlahTransaksi,
  });

  factory TransactionHeaderModel.fromJson(Map<String, dynamic> json) {
    return TransactionHeaderModel(
      id: int.parse(json['id'].toString()),
      date: json['date'].toString(),
      namaProduk: json["Nama_produk"] ?? "",
      isPromo: json['is_promo'] ?? false,
      promoType: json['promo_type'],
      totalPenjualan: double.parse(json['total_penjualan'].toString()),
      totalModal: double.parse(json['total_modal'].toString()),
      totalProfit: double.parse(json['total_profit'].toString()),
      items: json['items'] == null ? [] : (json['items'] as List).map((e) => TransactionItemModel.fromJson(e)).toList(),
    );
  }
}

class PaginatedTransac {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasMore;
  final List<TransactionHeaderModel> data;

  PaginatedTransac({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasMore,
    required this.data,
  });

  factory PaginatedTransac.fromJson(Map<String, dynamic> json) {
    return PaginatedTransac(
      page: json['page'],
      limit: json['limit'],
      totalItems: json['total_items'],
      totalPages: json['total_pages'],
      hasMore: json['has_more'],
      data: (json['data'] as List).map((e) => TransactionHeaderModel.fromJson(e)).toList(),
    );
  }
}
