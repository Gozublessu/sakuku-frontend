import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/models/insight_produk_model.dart';
import 'package:sakuku_desktop/models/restock_model.dart';
import 'package:sakuku_desktop/providers/product_insight_provider.dart';
import 'package:sakuku_desktop/providers/product_provider.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_basic_info.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_header.dart';

class RestockWorkspacePage extends StatefulWidget {
  final VoidCallback onBack;

  final ProductInsightResponse insight;
  const RestockWorkspacePage({
    super.key,
    required this.onBack,
    required this.insight,
  });
  @override
  State<RestockWorkspacePage> createState() => _RestockWorkSpace();
}

class _RestockWorkSpace extends State<RestockWorkspacePage> {
  final TextEditingController restockQtyController = TextEditingController();
  String rightPanelMode = "insight";
  bool updatePricing = false;
  final buyPriceController = TextEditingController();

  final sellPriceController = TextEditingController();

  @override
  void dispose() {
    restockQtyController.dispose();
    buyPriceController.dispose();

    sellPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restockQty = int.tryParse(
          restockQtyController.text,
        ) ??
        0;

    final product = widget.insight.product;
    final currentStock = widget.insight.product.stok;
    final buyPrice = widget.insight.product.hargaBeli;

    final updatedBuyPrice = updatePricing
        ? parseRupiah(
            buyPriceController.text,
          )
        : buyPrice;

    final updatedSellPrice = updatePricing
        ? parseRupiah(
            sellPriceController.text,
          )
        : widget.insight.product.hargaJual;
    final updatedMargin = updatedSellPrice - updatedBuyPrice;

    final updatedMarginPercent = updatedBuyPrice == 0 ? 0 : (updatedMargin / updatedBuyPrice) * 100;

    final avgDailySales = widget.insight.window7d.avg_7d;
    final recommendation = widget.insight.decision.recomendedRestock;
    final minRestock = recommendation?.minRestock ?? 0;

    final maxRestock = recommendation?.maxRestock ?? 0;

    final estimatedCost = restockQty * buyPrice;

    final stockAfterRestock = currentStock + restockQty;

    final estimatedCoverage = avgDailySales == 0 ? 0 : stockAfterRestock ~/ avgDailySales;

    return Container(
      width: 880,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue,
          width: 1.4,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromoHeader(
              title: "Create Restock",
              onBack: widget.onBack,
              productName: product.nama,
              netto: product.netto,
            ),
            const SizedBox(height: 24),
            PromoBasicInfo(
              buyPrice: rupiah(product.hargaBeli),
              sellPrice: rupiah(product.hargaJual),
              margin: "${product.marginPersen.toStringAsFixed(1)}%",
              stock: "${product.stok} Pcs",
              statCard: const SizedBox(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Recommended restock: "
                      "$minRestock - "
                      "$maxRestock pcs",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Pricing Strategy",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ChoiceChip(
                  label: const Text(
                    "Keep Current Price",
                  ),
                  selected: !updatePricing,
                  onSelected: (_) {
                    setState(() {
                      updatePricing = false;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text(
                    "Update Pricing",
                  ),
                  selected: updatePricing,
                  onSelected: (_) {
                    setState(() {
                      updatePricing = true;
                    });
                  },
                ),
              ],
            ),
            if (updatePricing) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: buyPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        final formatted = formatInputRupiah(
                          buyPriceController.text,
                        );

                        buyPriceController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );

                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        labelText: "New Buy Price",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: sellPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        final formatted = formatInputRupiah(
                          sellPriceController.text,
                        );

                        sellPriceController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );

                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        labelText: "New Sell Price",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "New Margin: "
                        "${rupiah(updatedMargin)} "
                        "(${updatedMarginPercent.toStringAsFixed(1)}%)",
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              child: TextField(
                controller: restockQtyController,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "Restock Qty",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _restockCard(
                  "Estimated Cost",
                  rupiah(estimatedCost),
                ),
                _restockCard(
                  "Stock After",
                  "$stockAfterRestock Pcs",
                ),
                _restockCard(
                  "Coverage",
                  "$estimatedCoverage Days",
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (restockQty <= 0) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Jumlah restock tidak valid",
                        ),
                      ),
                    );

                    return;
                  }
                  if (updatePricing && (updatedBuyPrice <= 0 || updatedSellPrice <= 0)) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Harga tidak valid",
                        ),
                      ),
                    );

                    return;
                  }
                  if (updatedSellPrice < updatedBuyPrice) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Harga jual tidak boleh lebih kecil dari harga beli",
                        ),
                      ),
                    );

                    return;
                  }
                  final request = RestockRequest(
                    jumlahProduk: restockQty,
                    hargaJual: updatedSellPrice.toDouble(),
                    hargaBeli: updatedBuyPrice.toDouble(),
                  );
                  final success = await context.read<ProductProvider>().restock(
                        kodeProduk: product.kodeProduk,
                        request: request,
                      );
                  if (success) {
                    await context.read<ProductProvider>().loadInitial();

                    await context.read<DeepInsightProvider>().loadInsight(
                          productId: widget.insight.product.id,
                        );

                    widget.onBack();

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Produk berhasil di restock",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Gagal update produk",
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.inventory_2,
                ),
                label: const Text(
                  "Execute Restock",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _restockCard(
    String title,
    String value,
  ) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
