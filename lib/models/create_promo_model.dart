class CreatePromoRequest {
  final int productId;

  final String? promoType;

  final String discountType;

  final double discountValue;

  final DateTime startDate;

  final DateTime endDate;

  final String scopeType;

  final int? customQty;

  final String profitStatus;

  final double promoPrice;

  final double promoMargin;

  final double promoMarginPercent;

  final double originalPrice;

  final double originalMargin;

  final double originalMarginPercent;

  final String notes;

  CreatePromoRequest({
    required this.productId,
    required this.promoType,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.scopeType,
    required this.profitStatus,
    required this.promoPrice,
    required this.promoMargin,
    required this.promoMarginPercent,
    required this.originalPrice,
    required this.originalMargin,
    required this.originalMarginPercent,
    required this.notes,
    this.customQty,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "promo_type": promoType,
      "discount_type": discountType,
      "discount_value": discountValue,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "scope_type": scopeType,
      "profit_status": profitStatus,
      "promo_price": promoPrice,
      "promo_margin": promoMargin,
      "promo_margin_percent": promoMarginPercent,
      "original_price": originalPrice,
      "original_margin": originalMargin,
      "original_margin_percent": originalMarginPercent,
      "notes": notes,
      "custom_qty": customQty,
    };
  }
}
