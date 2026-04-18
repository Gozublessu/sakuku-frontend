import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/tierl_list_model.dart';
import '../api/pipe_api.dart';
import 'package:sakuku_desktop/core/chart_range.dart';

class TierListProvider with ChangeNotifier {
  List<tierListItem> tierlist = [];
  bool isLoading = false;
  String? errorMessage;
  bool get hasInsightOpen => selectedIndex != null;

  /// UI STATE
  int currentPage = 2; // default = month
  int? selectedIndex;

  /// DATA STATE
  TierRange tierRange = TierRange.month;

  /// OPTIONAL CACHE (biar swipe ga reload terus)
  final Map<TierRange, List<tierListItem>> _cache = {};

  /// =========================
  /// 🔥 SET PAGE (DARI SLIDE)
  /// =========================
  void setPage(int index) {
    currentPage = index;

    final newRange = _indexToRange(index);

    if (tierRange == newRange) return;

    tierRange = newRange;
    selectedIndex = null; // reset insight

    notifyListeners();
    _fetch();
  }

  /// =========================
  /// 🔥 TAP ITEM (OPEN/CLOSE)
  /// =========================
  void toggleIndex(int index) {
    if (selectedIndex == index) {
      selectedIndex = null;
    } else {
      selectedIndex = index;
    }
    notifyListeners();
  }

  /// =========================
  /// 🔥 FETCH DATA
  /// =========================
  Future<void> _fetch() async {
    try {
      /// ✅ CACHE HIT
      if (_cache.containsKey(tierRange)) {
        tierlist = _cache[tierRange]!;
        notifyListeners();
        return;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final rangeStr = _mapRange(tierRange);

      final res = await TierListApi.getTierList(rangeStr);

      tierlist = res;
      _cache[tierRange] = res;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// =========================
  /// 🔥 HELPER
  /// =========================
  TierRange _indexToRange(int index) {
    switch (index) {
      case 0:
        return TierRange.today;
      case 1:
        return TierRange.week;
      case 2:
        return TierRange.month;
      case 3:
        return TierRange.all;
      default:
        return TierRange.month;
    }
  }

  String _mapRange(TierRange range) {
    switch (range) {
      case TierRange.today:
        return "today";
      case TierRange.week:
        return "week";
      case TierRange.month:
        return "month";
      case TierRange.all:
        return "all";
    }
  }

  /// =========================
  /// 🔥 INITIAL LOAD (WAJIB DIPANGGIL)
  /// =========================
  Future<void> init() async {
    await _fetch();
  }

  Future<void> loadForDashboard(TierRange range) async {
    tierRange = range;
    currentPage = _rangeToIndex(range); // sync UI kalau dipakai

    await _fetch();
  }

  int _rangeToIndex(TierRange range) {
    switch (range) {
      case TierRange.today:
        return 0;
      case TierRange.week:
        return 1;
      case TierRange.month:
        return 2;
      case TierRange.all:
        return 3;
    }
  }

  Future<void> initAll() async {
    print("INIT ALL JALAN");
    isLoading = true;
    notifyListeners();

    for (var range in TierRange.values) {
      final res = await TierListApi.getTierList(_mapRange(range));
      print("RANGE $range → ${res.length}");
      _cache[range] = res;
    }

    isLoading = false;
    notifyListeners();
  }
}
