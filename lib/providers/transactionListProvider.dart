import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/summary_model.dart';
import '../models/transactions_header_model.dart';
import '../api/pipe_api.dart';

class TransactionListProvider with ChangeNotifier {
  DateTime? filterDate;
  List<TransactionHeaderModel> transactions = [];
  int page = 1;
  final int limit = 50;

  bool isLoading = false;
  bool hasMore = true;
  bool isPaging = false; // KHUSUS transaksi list
  bool isSummaryLoading = false;
  // SummaryModel? dailySummary;
  List<SummaryModel> dailySummary = [];

  Future<void> loadInitial({DateTime? filteredDate}) async {
    page = 1;
    hasMore = true;
    filteredDate = filteredDate;
    transactions.clear();
    notifyListeners();

    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    print("➡️ loadNextPage CALLED | isPaging=$isPaging hasMore=$hasMore");
    if (isPaging || !hasMore) return;

    isPaging = true;
    notifyListeners();

    final resp = await TransactionApi.getPaginatedTransac(
      page,
      limit,
      date: filterDate,
    );

    if (resp.data.isEmpty) {
      hasMore = false;
      isPaging = false;
      notifyListeners();
      return;
    }

    transactions.addAll(resp.data);
    page++;
    hasMore = resp.hasMore;

    isPaging = false;
    notifyListeners();
  }

  Future<void> resetAndLoad({DateTime? filteredDate}) async {
    isPaging = false;
    hasMore = true;
    page = 1;

    filterDate = filteredDate;

    transactions.clear();
    notifyListeners();

    await loadNextPage();
  }

  Future<void> loadDailySummary(DateTime start, DateTime end) async {
    isSummaryLoading = true;
    notifyListeners();

    try {
      dailySummary = await TransactionApi.getSummary(
        startDate: start,
        endDate: end,
      );
    } catch (e) {
      print(e);
    } finally {
      isSummaryLoading = false;
      notifyListeners();
    }
  }
}
