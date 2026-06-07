import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/capital_model.dart';
import 'package:sakuku_desktop/models/dead_stock_model.dart';
import 'package:sakuku_desktop/models/highlight_update_model.dart';
import 'package:sakuku_desktop/models/new_produk_model.dart';
import 'package:sakuku_desktop/models/promo_model.dart';
import 'package:sakuku_desktop/models/tierl_list_model.dart';
import '../api/pipe_api.dart';
import '../models/low_stock.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardService service = DashboardService();

  LowStockResp? lowStock;
  tierListItem? topMoverWeekly;
  PromoModel? promoProduct;
  bool isLoading = false;
  bool isUpdateLoad = false;
  bool isUpDs = false;
  bool isUpNewProduk = false;
  CapitalModel? capitalAlert;
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

  Future<void> productPromo() async {
    print("MASUK PRODUCT PROMO");
    try {
      final res = await service.getPromoModel();

      print("PROMO API = $res");

      promoProduct = res;

      notifyListeners();
    } catch (e) {
      print("PROMO ERROR = $e");
    }
  }

  Future<void> loadCapital() async {
    try {
      final res = await service.getCapitalAlert();

      capitalAlert = res;
      notifyListeners();
    } catch (e) {
      print("CAPITAL ERROR = $e");
    }
  }

  Future<void> fetchTopMover() async {
    try {
      final res = await TierListApi.getTierList("week");

      if (res.items.isNotEmpty) {
        topMoverWeekly = res.items.first;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
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
