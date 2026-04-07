class SummaryModel {
  final String date;
  final double totalPenjualan;
  final double totalModal;
  final double totalProfit;
  final int jumlahTransaksi;

  SummaryModel({
    required this.totalPenjualan,
    required this.totalModal,
    required this.totalProfit,
    required this.date,
    required this.jumlahTransaksi,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      date: json['date'] ?? "",
      totalPenjualan: (json['total_penjualan'] ?? 0).toDouble(),
      totalModal: (json['total_modal'] ?? 0).toDouble(),
      totalProfit: (json['total_profit'] ?? 0).toDouble(),
      jumlahTransaksi: int.parse(json['jumlah_transaksi'].toString()),
    );
  }
  factory SummaryModel.empty(String date) {
    return SummaryModel(
      date: date,
      totalPenjualan: 0,
      totalModal: 0,
      totalProfit: 0,
      jumlahTransaksi: 0,
    );
  }
}
