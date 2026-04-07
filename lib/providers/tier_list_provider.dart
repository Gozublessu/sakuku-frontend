import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sakuku_desktop/models/tierl_list_model.dart';
import '../api/pipe_api.dart';
import 'package:sakuku_desktop/core/chart_range.dart';

class TierListProvider with ChangeNotifier {
  List<tierListItem> tierlist = [];
  bool isLoading = false;
  String? errorMessage;

  String? startDate;
  String? endDate;

  // Helper untuk formatting
  String _fmt(DateTime d) => DateFormat("yyyy-MM-dd").format(d);

  /// LOAD BY DATE (1 hari)
  Future<void> loadForDate(DateTime date) async {
    startDate = _fmt(date);
    endDate = _fmt(date);
    await _fetch();
  }

  /// LOAD BY RANGE
  Future<void> loadForRange(DateTime start, DateTime end) async {
    startDate = _fmt(start);
    endDate = _fmt(end);
    debugPrint('TierList range: $startDate → $endDate');
    await _fetch();
  }

  /// LOAD ALL TIME
  Future<void> loadAllTime() async {
    startDate = null;
    endDate = null;
    await _fetch(allTime: true);
  }

  // FETCH UTAMA
  Future<void> _fetch({bool allTime = false}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      List<tierListItem> res;

      if (allTime) {
        res = await TierListApi.getTierListAllTime();
      } else {
        res = await TierListApi.getTierList(startDate!, endDate!);
      }

      tierlist = res;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadByRange(ChartRange range) async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    if (range == ChartRange.month) {
      await loadForRange(
        today.subtract(const Duration(days: 29)), // bukan 30
        today,
      );
    } else if (range == ChartRange.week) {
      await loadForRange(
        today.subtract(const Duration(days: 6)),
        today,
      );
    } else {
      await loadAllTime();
      debugPrint("REQUEST RANGE: $startDate → $endDate");
    }
  }
}
