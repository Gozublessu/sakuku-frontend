class PromoModel {
  final String status;
  final String promoLabel;
  final String namaProduk;
  final num originalPrice;
  final num promoPrice;
  final String? notes;
  final int activeCount;
  final int schedule;
  final DateTime startDate;
  final DateTime endDate;
  final num daysRemaining;

  PromoModel({
    required this.status,
    required this.promoLabel,
    required this.namaProduk,
    required this.originalPrice,
    required this.notes,
    required this.promoPrice,
    required this.activeCount,
    required this.startDate,
    required this.endDate,
    required this.schedule,
    required this.daysRemaining,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      status: json['status'],
      promoLabel: json['promo_name'],
      namaProduk: json['product_name'],
      originalPrice: json['original_price'],
      promoPrice: json['promo_price'],
      notes: json['notes'] ?? '',
      activeCount: json['active_count'],
      schedule: json['scheduled_count'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      daysRemaining: json['days_remaining'],
    );
  }
}
