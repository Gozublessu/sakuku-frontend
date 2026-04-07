final autoMarginConfig = {
  "default": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "margin_persen": 30,
    "profit_minimal": 2000
  },
  "FOOD": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "profit_minimal": 2000
  },
  "DRINK": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "profit_minimal": 2000
  },
  "SHAMPOO": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "profit_minimal": 2000
  },
  "BODYWASH": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "profit_minimal": 2000
  },
  "COSMETIC": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "profit_minimal": 2000
  },
  "HANDBODY": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "profit_minimal": 2000
  },
  "FACIALFOAM": {
    "rules": [
      {
        "harga_beli": 2000,
        "margin_persen": 40
      },
      {
        "harga_beli": 10000,
        "margin_persen": 20
      },
      {
        "harga_beli": 30000,
        "margin_persen": 15
      },
      {
        "harga_beli": 50000,
        "margin_persen": 10
      },
      {
        "harga_beli": 100000,
        "margin_persen": 7
      }
    ],
    "profit_minimal": 2000
  }
};

int snapPrice(int price) {
  int remainder = price % 1000;

  if (remainder <= 500) {
    return price - remainder + 500;
  }

  if (remainder <= 900) {
    return price - remainder + 900;
  }

  return price - remainder + 1000;
}

int getAutoHargaJual(String? jenis, int hargaBeli) {
  final Map<String, dynamic> config = (autoMarginConfig[jenis] ?? autoMarginConfig["default"]) as Map<String, dynamic>;

  final rules = config["rules"] as List<dynamic>;
  final profitMin = (config["profit_minimal"] ?? 0) as int;
  final defaultMargin = (config["margin_persen"] as int?) ?? 0;

  int? margin;

  for (var rule in rules) {
    if (hargaBeli >= rule["harga_beli"]) {
      margin = rule["margin_persen"];
    }
  }

  margin ??= defaultMargin;

  int profit = (hargaBeli * margin ~/ 100);
  if (profit < profitMin) profit = profitMin;

  int harga = hargaBeli + profit;

  return snapPrice(harga);
}
