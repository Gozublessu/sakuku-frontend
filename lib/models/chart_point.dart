class ChartData {
  final DateTime date;
  final double penjualan;
  final double modal;

  ChartData({
    required this.date,
    required this.penjualan,
    required this.modal,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      date: DateTime.parse(json["date"]),
      penjualan: (json["penjualan"] as num).toDouble(),
      modal: (json["modal"] as num).toDouble(),
    );
  }
}
