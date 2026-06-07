class PromoModel {
  final String status;
  final int activeCount;
  final int schedule;
  final List<PromoItem> promos;

  PromoModel({
    required this.status,
    required this.activeCount,
    required this.schedule,
    required this.promos,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      status: json['status'] ?? 'NONE',
      activeCount: json['active_count'] ?? 0,
      schedule: json['scheduled_count'] ?? 0,
      promos: (json['promos'] as List<dynamic>?)
              ?.map(
                (e) => PromoItem.fromJson(e),
              )
              .toList() ??
          [],
    );
  }
}

class PromoItem {
  final String promoLabel;
  final String namaProduk;

  final num originalPrice;
  final num promoPrice;

  final String? notes;

  final DateTime startDate;
  final DateTime endDate;

  final num daysRemaining;

  PromoItem({
    required this.promoLabel,
    required this.namaProduk,
    required this.originalPrice,
    required this.promoPrice,
    required this.notes,
    required this.startDate,
    required this.endDate,
    required this.daysRemaining,
  });

  factory PromoItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return PromoItem(
      promoLabel: json['promo_name'] ?? '',
      namaProduk: json['product_name'] ?? '',
      originalPrice: json['original_price'] ?? 0,
      promoPrice: json['promo_price'] ?? 0,
      notes: json['notes'],
      startDate: DateTime.parse(
        json['start_date'],
      ),
      endDate: DateTime.parse(
        json['end_date'],
      ),
      daysRemaining: json['days_remaining'] ?? 0,
    );
  }
}
