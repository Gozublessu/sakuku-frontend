import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/transactions_header_model.dart';
import '../api/summary_api.dart';
import '../models/chart_point.dart';

class SummaryProvider with ChangeNotifier {
  DateTime? selectedStart;
  DateTime? selectedEnd;
  Map<String, dynamic>? allTimeSummary;
  Map<String, dynamic>? periodSummary;
  List<TransactionHeaderModel> transactionHeaders = [];
  List<ChartData> chartData = [];

  void setStart(DateTime? d) {
    selectedStart = d;
    notifyListeners();
  }

  void setEnd(DateTime? d) {
    selectedEnd = d;
    notifyListeners();
  }

  void clearPeriod() {
    chartData = [];
    periodSummary = null;
    notifyListeners();
  }

  Future<void> loadAllTime() async {
    allTimeSummary = await SummaryApi.getAllTimeSummary();
    notifyListeners();
  }

  Future<void> loadPeriod() async {
    if (selectedStart == null || selectedEnd == null) return;

    final start = selectedStart!;
    final end = selectedEnd!;

    final s = "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
    final e = "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

    print("DEBUG: Hit API -> /summary/period?start=$s&end=$e");

    final result = await SummaryApi.getPeriodSummary(s, e);
    periodSummary = result;
    //  parse chart
    if (result["chart"] != null) {
      chartData = (result["chart"] as List).map((e) => ChartData.fromJson(e)).toList();
    } else {
      chartData = [];
    }

    notifyListeners();
  }
}
