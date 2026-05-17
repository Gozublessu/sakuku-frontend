import 'dart:async';
import 'package:sakuku_desktop/models/create_promo_model.dart';
import 'package:sakuku_desktop/models/restock_model.dart';
import 'package:sakuku_desktop/models/update_meta_model.dart';
import 'package:flutter/material.dart';
import '../models/produk_model.dart';
import '../api/pipe_api.dart';

class ProductProvider with ChangeNotifier {
  final ProductAPI service = ProductAPI();

  Timer? _debounce;
  List<ProdukModel> allProducts = [];
  List<ProdukModel> products = [];

  int page = 1;
  int limit = 50;
  int totalProduk = 0;
  int grandTotal = 0;

  bool isLoading = false;
  bool hasMore = true;
  bool isLowStockMode = false;
  String search = "";
  String? selectedCategory;
  String? movementCategory;
  String? error;

  Future<void> loadInitial() async {
    page = 1;

    hasMore = true;
    products = [];
    isLoading = true;

    final resp = await getPaginated(
      page,
      limit,
      search: search,
      category: selectedCategory,
      movement: movementCategory,
      lowStock: isLowStockMode,
    );

    products = resp.data;
    hasMore = resp.hasMore;
    totalProduk = resp.totalItems;

    page++;

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    final resp = await getPaginated(
      page,
      limit,
      search: search,
      category: selectedCategory,
      movement: movementCategory,
      lowStock: isLowStockMode,
    );

    products.addAll(resp.data);
    hasMore = resp.hasMore;

    page++;

    isLoading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    search = value;
    _debounce?.cancel();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      loadInitial(); // reload data
    });
    // notifyListeners();
  }

  void toggleLowStockFilter() {
    isLowStockMode = !isLowStockMode;
    loadInitial();
  }

  Future<void> applyFilter({
    String? category,
    String? movement,
    required bool lowStock,
  }) async {
    selectedCategory = category;
    movementCategory = movement;
    isLowStockMode = lowStock;
    await loadInitial();
  }

  Future<bool> restock({
    required String kodeProduk,
    required RestockRequest request,
  }) async {
    final success = await restockProduct(kodeProduk, request);

    if (success) {
      await loadInitial();
    }

    return success;
  }

  Future<bool> updateMeta({
    required String kodeProduk,
    required UpdateMetaModel request,
  }) async {
    final succes = await updateProduct(kodeProduk, request);
    if (succes) {
      await loadInitial();
    }
    return succes;
  }

  Future<bool> createPromo({
    required CreatePromoRequest request,
  }) async {
    return await service.createPromo(
      request: request,
    );
  }

  String get summaryLabel {
    if (isLowStockMode) {
      return "Low Stock Products";
    }
    if (selectedCategory != null && selectedCategory != "All") {
      return "Total Products $selectedCategory";
    }
    if (search.isNotEmpty) {
      return "Search results";
    }
    return "Active Products";
  }
}
