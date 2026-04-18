import 'package:flutter/material.dart';
import '../models/insight_produk_model.dart';
import '../api/pipe_api.dart';

class ProductInsightProvider with ChangeNotifier {
  final ProductInsightService service = ProductInsightService();

  ProductInsightResponse? insight;
  bool isLoading = false;
  String? errorMessage;
  int? selectedRank;

  Future<void> loadInsight({
    required int productId,
    required int rank,
  }) async {
    final start = DateTime.now();
    selectedRank = rank;
    print("🔥 loadInsight terpanggil dengan ID: $productId");
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final elapsed = DateTime.now().difference(start);

    if (elapsed < Duration(milliseconds: 300)) {
      await Future.delayed(
        Duration(milliseconds: 300) - elapsed,
      );
    }

    try {
      final result = await service.fetchInsight(productId);
      insight = result;
      // print("🔥 PROVIDER (${this.hashCode}) - insight SET: ${insight != null}");
    } catch (e) {
      errorMessage = "Gagal memuat insight: $e";
      print("🔥 PROVIDER (${this.hashCode}) - FETCH ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
    // print("🔥 PROVIDER (${this.hashCode}) - isLoading=false, insight present: ${insight != null}");
  }

  void clearInsight() {
    insight = null;
    notifyListeners();
  }
}

class DeepInsightProvider with ChangeNotifier {
  final ProductInsightService service = ProductInsightService();

  ProductInsightResponse? insight;
  bool isLoading = false;
  String? errorMessage;
  int? selectedId;

  Future<void> loadInsight({
    required int productId,
  }) async {
    final start = DateTime.now();

    selectedId = productId;
    isLoading = true;
    errorMessage = null;
    print("🔥 loadInsight terpanggil dengan ID: $productId");

    notifyListeners();

    final elapsed = DateTime.now().difference(start);

    if (elapsed < Duration(milliseconds: 300)) {
      await Future.delayed(
        Duration(milliseconds: 300) - elapsed,
      );
    }

    try {
      final result = await service.fetchInsight(productId);
      insight = result;
      // print("🔥 PROVIDER (${this.hashCode}) - insight SET: ${insight != null}");
    } catch (e) {
      errorMessage = "Gagal memuat insight: $e";
      print("🔥 PROVIDER (${this.hashCode}) - FETCH ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
    // print("🔥 PROVIDER (${this.hashCode}) - isLoading=false, insight present: ${insight != null}");
  }

  void clearInsight() {
    insight = null;
    notifyListeners();
  }
}
