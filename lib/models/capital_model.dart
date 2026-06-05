class CapitalModel {
  final num totalIdleCapital;
  final num top3Contribution;
  final int totalProduct;
  final List<Product> products;
  CapitalModel({
    required this.totalIdleCapital,
    required this.top3Contribution,
    required this.totalProduct,
    required this.products,
  });

  factory CapitalModel.fromJson(Map<String, dynamic> json) {
    return CapitalModel(
      totalIdleCapital: json['total_idle_capital'],
      top3Contribution: json['top3_contribution'],
      totalProduct: json['total_products'],
      products: (json['products'] as List).map((e) => Product.fromJson(e)).toList(),
    );
  }
}

class Product {
  final int productId;
  final String nameProduct;
  final num idleCapital;
  final int coverageDay;

  Product({
    required this.productId,
    required this.idleCapital,
    required this.nameProduct,
    required this.coverageDay,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json["product_id"],
      nameProduct: json['product_name'],
      idleCapital: json['idle_capital'],
      coverageDay: json['coverage_day'],
    );
  }
}
