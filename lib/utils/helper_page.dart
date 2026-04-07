import 'package:intl/intl.dart';

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
