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
  "STRONG RESTOCK": Colors.green,
  "RESTOCK": Colors.blue,
  "RESTOCK WITH CAUTION": Colors.orange,
  "MONITOR PRODUCT": Colors.grey,
  "STOP RESTOCK": Colors.red,
  "NEW PRODUCT": Colors.purple,
};

// class _CardDeepInsightState extends State<CardDeepInsightReport> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DeepInsightProvider>(
//       builder: (context, provider, _) {
//         if (provider.isLoading) {
//           return const LoadingState(
//             text: "Analyzing product...",
//           );
//         }

//         if (provider.insight == null) {
//           return SizedBox(
//             height: 300,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.insights_outlined,
//                   size: 55,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   "Pilih produk dulu",
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 24,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//         final data = provider.insight!;

//         final action = data.decision.finalAction;
//         final baseColor = actionColors[action] ?? Colors.grey;

//         return Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🔥 HEADER
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           data.product.nama,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           data.classification.movement,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           "Action recommendations",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: baseColor,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             action,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: 16),
//                 Divider(),

//                 // 🔥 SUMMARY
//                 Text("Summary lifetime", style: TextStyle(fontWeight: FontWeight.w600)),
//                 SizedBox(height: 2),
//                 Text(data.narrative?.summary ?? "-"),

//                 SizedBox(height: 16),

//                 // 🔥 METRICS ROW
//                 Row(
//                   children: [
//                     _metricBox("Sold", data.summary.totalQty),
//                     _metricBox("Profit", rupiah(data.summary.totalProfit)),
//                     _metricBox("Stock", data.product.stok),
//                   ],
//                 ),

//                 SizedBox(height: 12),

//                 // 🔥 CHART (placeholder dulu)
//                 Text("Chart Highlights", style: TextStyle(fontWeight: FontWeight.w600)),
//                 SizedBox(height: 2),
//                 // Text("Chart di tampilkan berdasarkan penjualan 7 hari terakhir."),
//                 Divider(),

//                 buildSalesChart(
//                   data.dailySales,
//                   data.trend.velocityShift,
//                 ),

//                 SizedBox(height: 16),

//                 // 🔥 RECOMMENDATION
//                 Text("Recommendation", style: TextStyle(fontWeight: FontWeight.w600)),
//                 SizedBox(height: 8),
//                 Text("Pertimbangkan perasaan dan logika anda."),
//                 Divider(),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // 🔥 KIRI
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Detail analysis", style: TextStyle(fontWeight: FontWeight.w600)),
//                           SizedBox(height: 8),
//                           _infoItem("Selling Days:", "${data.metricsLifeTime.selling} days"),
//                           _infoItem("Lost Days:", "${data.metricsLifeTime.lostDay} days"),
//                           _infoItem("Active Days:", "${data.metricsLifeTime.daysActive} days"),
//                           _infoItem("Age Days:", "${data.metricsLifeTime.ageProduct} days"),
//                           _infoItem("Transaction count:", "${data.metricsLifeTime.transactionCount} x"),
//                         ],
//                       ),
//                     ),

//                     // 🔥 KANAN
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Classification", style: TextStyle(fontWeight: FontWeight.w600)),
//                           SizedBox(height: 8),
//                           _infoItem("Movement:", data.classification.movement),
//                           _infoItem("Signal Stock:", data.classification.signalStock),
//                           _infoItem("Signal profit:", data.classification.signalProfit),
//                           _infoItem("Insight:", data.classification.inisght),
//                           _infoItem("Detect demand:", data.classification.detectDemand),
//                           _infoItem("Detect stability:", data.classification.demandStability),
//                           _infoItem("Detect trend:", data.classification.detectTrend),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Based information", style: TextStyle(fontWeight: FontWeight.w600)),
//                           SizedBox(height: 8),
//                           _infoItem("Id:", data.product.id),
//                           _infoItem("Name:", data.product.nama),
//                           _infoItem("Category:", data.product.kategori),
//                           _infoItem("Date in:", formatDate2(data.product.dateIn)),
//                           _infoItem("Buy purchase:", rupiah(data.product.hargaBeli)),
//                           _infoItem("Sell purchase:", rupiah(data.product.hargaJual)),
//                           _infoItem("margin:", rupiah(data.product.marginRp)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Text("Report recap", style: TextStyle(fontWeight: FontWeight.w600)),
//                 SizedBox(height: 8),
//                 Text(data.narrative?.summary ?? "-"),
//                 Divider(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: (data.narrative?.highlights ?? []).map((h) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("• "),
//                           Expanded(child: Text(h)),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _infoItem(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start, // 🔥 penting
//         children: [
//           SizedBox(
//             width: 120, // 🔥 fix lebar label
//             child: Text(
//               label,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value.toString(),
//               softWrap: true,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _metricBox(String label, dynamic value) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         margin: const EdgeInsets.only(right: 8),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value.toString(),
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                const Text("Why this decision?", style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: data.decision.reasons.map((r) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(r, style: const TextStyle(fontSize: 11)),
                    );
                  }).toList(),
                ),

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
