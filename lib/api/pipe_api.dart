import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:sakuku_desktop/models/dead_stock_model.dart';
import 'package:sakuku_desktop/models/highlight_update_model.dart';
import 'package:sakuku_desktop/models/low_stock.dart';
import 'package:sakuku_desktop/models/new_produk_model.dart';
import 'package:sakuku_desktop/models/restock_model.dart';
import 'package:sakuku_desktop/models/summary_model.dart';
import 'package:sakuku_desktop/models/transactions_header_model.dart';
import 'package:sakuku_desktop/models/update_meta_model.dart';
import '../models/produk_model.dart';
import '../models/tierl_list_model.dart';
import 'package:intl/intl.dart';
import '../models/insight_produk_model.dart';

final dio = Dio(BaseOptions(
  baseUrl: "http://127.0.0.1:8000",
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
));

final String baseUrl = "http://localhost:8000";

Future<int> fetchTotalProduk() async {
  final response = await http.get(Uri.parse("$baseUrl/products/produk/total"));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData["total"] ?? 0; //
  } else {
    throw Exception("Gagal fetch total produk");
  }
}

Future<PaginatedProduct> getPaginated(
  int page,
  int limit, {
  String search = "",
  String? category,
  String? movement,
  bool lowStock = false,
}) async {
  final queryParams = {
    'page': page.toString(),
    'limit': limit.toString(),
    'search': search,
    if (category != null && category.isNotEmpty && category != 'All') 'category': category,
    if (movement != null && movement.isNotEmpty && movement != 'All') 'movement': movement,
    if (lowStock) 'low_stock': 'true'
  };

  final uri = Uri.parse('$baseUrl/products/get_paginated_product').replace(
    queryParameters: queryParams,
  );

  final resp = await http.get(uri);

  if (resp.statusCode != 200) {
    throw Exception('Failed to load products');
  }

  return PaginatedProduct.fromJson(jsonDecode(resp.body));
}

Future<bool> apiImportExcel(String filePath) async {
  var request = http.MultipartRequest(
    "POST",
    Uri.parse("http://localhost:8000/products/update-products-excel"),
  );

  request.files.add(
    await http.MultipartFile.fromPath("file", filePath),
  );

  var response = await request.send();
  return response.statusCode == 200;
}

class ProductAPI {
  static Future<String?> addProduct({
    required String nama,
    required String jenis,
    required String netto,
    required double hargaBeli,
    required double hargaJual,
    required double marginPersen,
    required int stok,
  }) async {
    final response = await http.post(Uri.parse("http://127.0.0.1:8000/products/"),
        headers: {
          "Content-type": "application/json"
        },
        body: jsonEncode(
          {
            "Nama_produk": nama,
            "Jenis_produk": jenis,
            "NETTO": netto,
            "Harga_beli": hargaBeli,
            "Harga_jual": hargaJual.isNaN ? null : hargaJual,
            "Margin_persen": marginPersen,
            "Jumlah_produk": stok,
          },
        ));

    print("BODY   : ${response.body}");
    print("STATUS : ${response.statusCode}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return null; // success
    } else {
      return data["detail"] ?? "Failed to add product";
    }
  }
}

Future<bool> updateProduct(String kodeProduk, UpdateMetaModel request) async {
  final url = Uri.parse("http://127.0.0.1:8000/products/$kodeProduk/edit");

  final response = await http.put(
    url,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode(request.toJson()),
  );

  print("Status: ${response.statusCode}");
  print("Response: ${response.body}");

  return response.statusCode == 200;
}

Future<bool> restockProduct(String kodeProduk, RestockRequest request) async {
  final url = Uri.parse(
    "http://127.0.0.1:8000/products/$kodeProduk/restock",
  );

  final response = await http.put(
    url,
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode(request.toJson()),
  );

  return response.statusCode == 200;
}

class TransactionApi {
  static Future<List<SummaryModel>> getSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final res = await dio.get(
      "/transaction/summary",
      queryParameters: {
        "start": startDate.toIso8601String(),
        "end": endDate.toIso8601String(),
      },
    );
    return (res.data as List).map((e) => SummaryModel.fromJson(e)).toList();
  }

  static Future<dynamic> getTransactionDetail(int id) async {
    final res = await dio.get("/transactions/$id");
    return res.data;
  }

  static Future<PaginatedTransac> getPaginatedTransac(int page, int limit, {DateTime? date}) async {
    final dateParam = date != null ? "&date=${DateFormat('yyyy-MM-dd').format(date)}" : "";

    final url = "$baseUrl/transaction?page=$page&limit=$limit$dateParam";

    final resp = await http.get(Uri.parse(url));

    return PaginatedTransac.fromJson(jsonDecode(resp.body));
  }
}

class TierListApi {
  static final dio = Dio(BaseOptions(baseUrl: "http://localhost:8000"));

  // RANGE DATE
  static Future<List<tierListItem>> getTierList(String range) async {
    final res = await dio.get(
      "/transaction/tierlist",
      queryParameters: {
        "range": range
      },
    );

    return (res.data as List).map((e) => tierListItem.fromJson(e)).toList();
  }

  // ALL TIME
  static Future<List<tierListItem>> getTierListAllTime() async {
    final res = await dio.get("/transaction/tierlist/all");

    return (res.data as List).map((e) => tierListItem.fromJson(e)).toList();
  }
}

class ProductInsightService {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8000"));

  Future<ProductInsightResponse> fetchInsight(int productId) async {
    try {
      final res = await dio.get("/products/insight/$productId");
      // print("🔥 RAW RESPONSE: ${res.data}");

      if (res.statusCode == 200) {
        return ProductInsightResponse.fromJson(res.data);
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      throw Exception("Gagal memuat insight: $e");
    }
  }
}

class DashboardService {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8000"));

  Future<LowStockResp> getLowStock() async {
    final resp = await dio.get("/products/low-stock");
    return LowStockResp.fromJson(resp.data);
  }

  Future<List<HighlightUpdateModel>> getUpdateStatus() async {
    final resp = await dio.get("/snapshot/status");
    final List list = resp.data;

    return list.map((e) => HighlightUpdateModel.fromJson(e)).toList();
  }

  Future<List<DeadStockModel>> velocityProduct() async {
    final resp = await dio.get("/transaction/velocity-product");
    final List list = resp.data;
    return list.map((e) => DeadStockModel.fromJson(e)).toList();
  }

  Future<List<NewProdukModel>> getNewProduk() async {
    final resp = await dio.get("/snapshot/newproduct");
    final List list = resp.data;
    return list.map((e) => NewProdukModel.fromJson(e)).toList();
  }
}
