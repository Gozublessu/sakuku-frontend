import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String rupiah(num value, {bool noMinus = false}) {
  final v = noMinus ? value.abs() : value;
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(v);
}

String formatDate(String isoDate) {
  final date = DateTime.parse(isoDate);
  return DateFormat("dd MMM yyyy, HH:mm").format(date);
}

String formatDate2(dynamic raw) {
  final date = raw is DateTime ? raw : DateTime.tryParse(raw.toString());
  if (date == null) return raw.toString();
  return DateFormat("dd MMM yyyy – HH:mm").format(date);
}

String formatNetto(String raw) {
  final value = raw.trim().toLowerCase();

  // ambil angka
  final numberMatch = RegExp(r'\d+').firstMatch(value);
  if (numberMatch == null) return raw;

  final number = numberMatch.group(0)!;

  // tentukan satuan
  if (value.contains('ml')) {
    return '$number ml';
  }
  if (value.contains('gr') || value.contains('g')) {
    return '$number g';
  }

  return raw; // fallback
}

int parseRupiah(String text) {
  final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(clean) ?? 0;
}

double parseRupiahDouble(String text) {
  final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
  return double.tryParse(clean) ?? 0;
}

double calculateDiscountedPrice(
  double originalPrice,
  double discountPercent,
) {
  return originalPrice - (originalPrice * discountPercent / 100);
}

enum DiscountType {
  percentage,
  nominal,
}

String formatInputRupiah(String value) {
  final number = parseRupiah(value);

  return NumberFormat.decimalPattern(
    'id_ID',
  ).format(number);
}

class ProductAction {
  final String label;
  final IconData icon;
  final String type;

  ProductAction({
    required this.label,
    required this.icon,
    required this.type,
  });
}

List<ProductAction> generateActions(
  List<String> reasons,
) {
  final actions = <ProductAction>[];

  final has = reasons.contains;

  // 🔥 RESTOCK
  if (has("CRITICAL STOCK") && has("MOVEMENT:FAST")) {
    actions.add(
      ProductAction(
        label: "Restock",
        icon: Icons.inventory_2,
        type: "RESTOCK",
      ),
    );
  }
  if (has("LOW STOCK") && has("STABLE DEMAND")) {
    actions.add(
      ProductAction(
        label: "Restock",
        icon: Icons.inventory_2,
        type: "RESTOCK",
      ),
    );
  }

  // 🔥 PROMO
  if (has("OVER STOCK") && has("MOVEMENT:SLOW")) {
    actions.add(
      ProductAction(
        label: "Create Promo",
        icon: Icons.local_offer,
        type: "PROMO",
      ),
    );
  }

  // 🔥 CAMPAIGN
  if (has("VERY STABLE") && has("HEALTHY STOCK")) {
    actions.add(
      ProductAction(
        label: "Campaign Push",
        icon: Icons.campaign,
        type: "CAMPAIGN",
      ),
    );
  }
  if (has("DECLINING DEMAND") && has("OVER STOCK")) {
    actions.add(ProductAction(
      label: "Campaign Push",
      icon: Icons.campaign,
      type: "CAMPAIGN",
    ));
  }

  return actions;
}
