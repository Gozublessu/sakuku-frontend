import 'package:sakuku_desktop/models/transactions_header_model.dart';
import 'package:sakuku_desktop/models/transactions_item_model.dart';

class TransactionDetailModel {
  final TransactionHeaderModel header;
  final List<TransactionItemModel> items;

  TransactionDetailModel({
    required this.header,
    required this.items,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    return TransactionDetailModel(
      header: TransactionHeaderModel.fromJson(json["header"]),
      items: (json["items"] as List).map((e) => TransactionItemModel.fromJson(e)).toList(),
    );
  }
}
