import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/pages/helper/info_card.dart';
import 'package:sakuku_desktop/providers/product_insight_provider.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

// class CardDeepInsightReport extends StatefulWidget {
//   const CardDeepInsightReport({super.key});
//   @override
//   State<CardDeepInsightReport> createState() => _CardDeepInsightState();
// }

Map<String, Color> actionColors = {
  "STRONG PRODUCT": Colors.green,
  "HEALTHY PRODUCT": Colors.blue,
  "RESTOCK WITH CAUTION": Colors.orange,
  "MONITOR PRODUCT": Colors.grey,
  "STOP RESTOCK": Colors.red,
  "NEW PRODUCT": Colors.purple,
};

class CardDeepInsightReport extends StatelessWidget {
  const CardDeepInsightReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DeepInsightProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const LoadingState(text: "Analyzing product...");
        }

        if (provider.insight == null) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insights_outlined,
                size: 45,
                color: Colors.blue,
              ),
              Text(
                "Pilih produk dahulu",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }

        final data = provider.insight!;
        final action = data.decision.finalAction;

        final baseColor = actionColors[action] ?? Colors.grey;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 HEADER
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.product.nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(data.classification.movement, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        action,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 16),

                // 🔥 MAIN INSIGHT
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: baseColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.narrative?.summary ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ...data.narrative!.highlights.map((h) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• "),
                                Expanded(child: Text(h)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔥 CHART
                const Text("7 Days Sales Trend", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                buildSalesChart(
                  data.dailySales,
                  data.trend.velocityShift,
                ),

                const SizedBox(height: 16),

                // 🔥 QUICK METRICS
                Row(
                  children: [
                    _metricBox("Sold", data.summary.totalQty),
                    _metricBox("Profit", rupiah(data.summary.totalProfit)),
                    _metricBox("Stock", data.product.stok),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔥 WHY SECTION
                // const Text("Why this decision?", style: TextStyle(fontWeight: FontWeight.w600)),
                // const SizedBox(height: 8),
                // Wrap(
                //   spacing: 6,
                //   runSpacing: 6,
                //   children: data.decision.reasons.map((r) {
                //     return Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                //       decoration: BoxDecoration(
                //         color: Colors.grey[200],
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //       child: Text(r, style: const TextStyle(fontSize: 11)),
                //     );
                //   }).toList(),
                // ),

                const SizedBox(height: 16),

                // 🔥 ADVANCED DETAILS
                ExpansionTile(
                  title: const Text("Advanced details"),
                  children: [
                    _infoItem("Selling Days", "${data.metricsLifeTime.selling}"),
                    _infoItem("Lost Days", "${data.metricsLifeTime.lostDay}"),
                    _infoItem("Active Days", "${data.metricsLifeTime.daysActive}"),
                    _infoItem("Transaction", "${data.metricsLifeTime.transactionCount}"),
                    _infoItem("Category", data.product.kategori),
                    _infoItem("Buy Price", rupiah(data.product.hargaBeli)),
                    _infoItem("Sell Price", rupiah(data.product.hargaJual)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _metricBox(String label, dynamic value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
