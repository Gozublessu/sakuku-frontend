class ProductInsightResponse {
  final ProductData product;
  final SummaryData summary;
  final PeakDay peakDay;
  final Classification classification;
  final LifetimeStats metricsLifeTime;
  final Decision decision;
  final Narrative? narrative;
  final List<DailySale> dailySales;
  final List<RestockHistory> restockHistory;
  final Trend trend;

  ProductInsightResponse({
    required this.product,
    required this.summary,
    required this.peakDay,
    required this.dailySales,
    required this.restockHistory,
    required this.classification,
    required this.metricsLifeTime,
    required this.decision,
    required this.narrative,
    required this.trend,
  });

  factory ProductInsightResponse.fromJson(Map<String, dynamic> json) {
    // print("🔥 FULL RESPONSE: $json");
    return ProductInsightResponse(
      product: ProductData.fromJson(json['product']),
      summary: SummaryData.fromJson(json['summary']),
      metricsLifeTime: LifetimeStats.fromJson(json['summary']['metrics']['lifetime']),
      classification: Classification.fromJson(json['summary']['classification']),
      decision: Decision.fromJson(json['summary']['decision']),
      narrative: json['summary']['narrativetxt'] != null ? Narrative.fromJson(json['summary']['narrativetxt']) : null,
      peakDay: PeakDay.fromJson(json['peak_day']),
      dailySales: (json['daily_sales'] as List).map((e) => DailySale.fromJson(e)).toList(),
      restockHistory: (json['restock_history'] as List).map((e) => RestockHistory.fromJson(e)).toList(),
      trend: Trend.fromJson(json['summary']['metrics']['trend']),
    );
  }
}

class ProductData {
  final int id;
  final String nama;
  final String kategori;
  final String netto;
  final num hargaJual;
  final num hargaBeli;
  final int stok;
  final num marginRp;
  final num marginPersen;
  final DateTime dateIn;
  final int stokAwal;
  final int totalStokMasuk;

  ProductData({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.netto,
    required this.hargaJual,
    required this.hargaBeli,
    required this.stok,
    required this.marginRp,
    required this.marginPersen,
    required this.dateIn,
    required this.stokAwal,
    required this.totalStokMasuk,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      nama: json['nama'],
      kategori: json['kategori'],
      netto: json['netto'],
      hargaJual: json['harga_jual'],
      hargaBeli: json['harga_beli'],
      stok: json['stok'],
      marginRp: json['margin_rp'],
      marginPersen: json['margin_persen'],
      dateIn: DateTime.parse(json['date_in']),
      stokAwal: json['stok_awal'],
      totalStokMasuk: json['total_stok_masuk'],
    );
  }
}

class SummaryData {
  final num totalQty;
  final num totalJual;
  final num totalModal;
  final num totalProfit;
  final DateTime? firstSold;
  final DateTime? lastSold;

  SummaryData({
    required this.totalQty,
    required this.totalJual,
    required this.totalModal,
    required this.totalProfit,
    this.firstSold,
    this.lastSold,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      totalQty: json['total_qty'],
      totalJual: json['total_jual'],
      totalModal: json['total_modal'],
      totalProfit: json['total_profit'],
      firstSold: json['first_sold'] != null ? DateTime.parse(json['first_sold']) : null,
      lastSold: json['last_sold'] != null ? DateTime.parse(json['last_sold']) : null,
    );
  }
}

class Classification {
  final String movement;
  final String signalStock;
  final String signalProfit;
  final String inisght;
  final String detectDemand;
  final String demandStability;
  final String detectDeepPattern;
  final String detectTrend;

  Classification({
    required this.movement,
    required this.signalStock,
    required this.signalProfit,
    required this.inisght,
    required this.detectDemand,
    required this.demandStability,
    required this.detectDeepPattern,
    required this.detectTrend,
  });

  factory Classification.fromJson(Map<String, dynamic> json) {
    return Classification(
      movement: json['movement'],
      signalStock: json['signal_stock'],
      signalProfit: json['signal_profit'],
      inisght: json['insight'],
      detectDemand: json['detect_demand'],
      demandStability: json['demand_stability'],
      detectDeepPattern: json['detect_deep_pattern'],
      detectTrend: json['detect_trend'],
    );
  }
}

class PeakDay {
  final DateTime? date;
  final int? qty;

  PeakDay({
    this.date,
    this.qty,
  });

  factory PeakDay.fromJson(Map<String, dynamic> json) {
    return PeakDay(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      qty: json['qty'] ?? 0,
    );
  }
}

class DailySale {
  final DateTime date;
  final int qty;

  DailySale({
    required this.date,
    required this.qty,
  });

  factory DailySale.fromJson(Map<String, dynamic> json) {
    return DailySale(
      date: DateTime.parse(json['date']),
      qty: json['qty'],
    );
  }
}

class RestockHistory {
  final DateTime date;
  final int qty;
  final bool isInitial;

  RestockHistory({
    required this.date,
    required this.qty,
    required this.isInitial,
  });

  factory RestockHistory.fromJson(Map<String, dynamic> json) {
    return RestockHistory(
      date: DateTime.parse(json['date']),
      qty: json['qty'],
      isInitial: json['is_initial'],
    );
  }
}

class LifetimeStats {
  final num daysActive;
  final num selling;
  final num ageProduct;
  final num lostDay;
  final num transactionCount;

  LifetimeStats({
    required this.daysActive,
    required this.selling,
    required this.ageProduct,
    required this.lostDay,
    required this.transactionCount,
  });

  factory LifetimeStats.fromJson(Map<String, dynamic> json) {
    return LifetimeStats(
      daysActive: json['days_active'],
      selling: json['selling_days'],
      ageProduct: json['age_product'],
      lostDay: json['lost_days'],
      transactionCount: json['transaction_count'],
    );
  }
}

class Decision {
  final String finalAction;
  final List<String> reasons;

  Decision({
    required this.finalAction,
    required this.reasons,
  });

  factory Decision.fromJson(Map<String, dynamic> json) {
    return Decision(
      finalAction: json['final_action'],
      reasons: List<String>.from(json['reasons']),
    );
  }
}

class Narrative {
  final String headline;
  final String summary;
  final List<String> highlights;
  final List<String> reasons;

  Narrative({
    required this.headline,
    required this.summary,
    required this.highlights,
    required this.reasons,
  });

  factory Narrative.fromJson(Map<String, dynamic> json) {
    return Narrative(
      headline: json["headline"],
      summary: json["summary"],
      highlights: json['highlights'] != null ? List<String>.from(json['highlights']) : [],
      reasons: json['reasons'] != null ? List<String>.from(json['reasons']) : [],
    );
  }
}

class ChartPoint {
  final DateTime date;
  final int qty;

  ChartPoint(this.date, this.qty);
}

class Trend {
  final double velocityShift;

  Trend({
    required this.velocityShift,
  });

  factory Trend.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Trend(velocityShift: 0); // default aman
    }
    return Trend(
      velocityShift: (json['velocity_shift'] ?? 0).toDouble(),
    );
  }
}
