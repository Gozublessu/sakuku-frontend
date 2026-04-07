import 'package:dio/dio.dart';

class SummaryApi {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000/summary",
  ));

  static Future<Map<String, dynamic>> getAllTimeSummary() async {
    final response = await dio.get("/");
    return response.data;
  }

  static Future<Map<String, dynamic>> getPeriodSummary(String start, String end) async {
    final response = await dio.get(
      "/period",
      queryParameters: {
        "start": start,
        "end": end,
      },
    );
    return response.data;
  }
}
