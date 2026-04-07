import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/dead_stock_model.dart';
import 'package:sakuku_desktop/models/highlight_update_model.dart';
import 'package:sakuku_desktop/models/new_produk_model.dart';
import '../api/pipe_api.dart';
import '../models/low_stock.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService service = DashboardService();

  LowStockResp? lowStock;
  bool isLoading = false;
  bool isUpdateLoad = false;
  bool isUpDs = false;
  bool isUpNewProduk = false;
  List<NewProdukModel> updatesNP = [];
  List<HighlightUpdateModel> updates = [];
  List<DeadStockModel> updatesDt = [];

  Future<void> fetchLowStock() async {
    isLoading = true;
    notifyListeners();

    try {
      lowStock = await service.getLowStock();
    } catch (e) {
      print("❌ Error fetch low stock: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUpdate() async {
    isUpdateLoad = true;
    notifyListeners();

    try {
      updates = await service.getUpdateStatus();
    } catch (e) {
      print("Errorc fetch update : $e");
    }
    isUpdateLoad = false;
    notifyListeners();
  }

  Future<void> getDeadStock() async {
    isUpDs = true;
    notifyListeners();

    try {
      updatesDt = await service.velocityProduct();
    } catch (e) {
      print(" Error get DeadStock : $e");
    }
    isUpDs = false;
    notifyListeners();
  }

  Future<void> getNewProduct() async {
    isUpNewProduk = true;
    notifyListeners();

    try {
      updatesNP = await service.getNewProduk();
    } catch (e) {
      print("error get newProduk : $e");
      isUpNewProduk = false;
      notifyListeners();
    }
  }
}
