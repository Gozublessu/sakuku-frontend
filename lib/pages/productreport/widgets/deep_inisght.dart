import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/models/insight_produk_model.dart';
import 'package:sakuku_desktop/pages/helper/info_card.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/helper_page.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/restock_workspace/restock_history_card.dart';
import 'package:sakuku_desktop/providers/product_insight_provider.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

Map<String, Color> actionColors = {
  "STRONG PRODUCT": Colors.green,
  "HEALTHY PRODUCT": Colors.blue,
  "RESTOCK WITH CAUTION": Colors.orange,
  "MONITOR PRODUCT": Colors.grey,
  "STOP RESTOCK": Colors.red,
  "NEW PRODUCT": Colors.purple,
};

class CardDeepInsightReport extends StatelessWidget {
  final VoidCallback? onCreatePromo;
  final VoidCallback? onRestock;
  final VoidCallback? onCampaignPush;
  final List<RestockHistory> histories;
  final num avgInterval;

  const CardDeepInsightReport({
    super.key,
    required this.onCreatePromo,
    required this.onRestock,
    required this.onCampaignPush,
    required this.histories,
    required this.avgInterval,
  });

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
                "Your business workspace is ready.",
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
        final actions = data.ctaEngine;
        final hasCapitalCTA = data.ctaCapital != null;

        final baseColor = actionColors[action] ?? Colors.grey;
        // print("CTA CAPITAL = ${data.ctaCapital}");
        // print("HAS CAPITAL = $hasCapitalCTA");

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 HEADER
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: data.product.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " ${normalizeNetto(data.product.netto)}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          data.classification.movement,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data.classification.recentMovement,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (data.promoProduct.promoStatus != null) PromoBadge(data: data),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            action,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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

                // 🔥 ADVANCED DETAILS
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    minTileHeight: 0,
                    childrenPadding: const EdgeInsets.only(
                      left: 5,
                      right: 12,
                      bottom: 12,
                    ),
                    title: const Text(
                      "Advanced Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _infoCard("Selling Days", "${data.metricsLifeTime.selling}"),
                            _infoCard("Lost Days", "${data.metricsLifeTime.lostDay}"),
                            _infoCard("Active Days", "${data.metricsLifeTime.daysActive}"),
                            _infoCard("Transaction", "${data.metricsLifeTime.transactionCount}"),
                            _infoCard("Category", data.product.kategori),
                            _infoCard("Buy Price", rupiah(data.product.hargaBeli)),
                            _infoCard("Sell Price", rupiah(data.product.hargaJual)),
                            _infoCard("Total Selling", rupiah(data.summary.totalJual)),
                            _infoCard("Margin Per Pcs", rupiah(data.product.marginRp)),
                            _infoCard("Supplier", "No Brand"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    minTileHeight: 0,
                    childrenPadding: const EdgeInsets.only(
                      left: 5,
                      right: 12,
                      bottom: 12,
                    ),
                    title: const Text(
                      "History Restock",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    children: [
                      RestockHistoryCard(
                        histories: histories,
                        avgInterval: avgInterval,
                      ),
                    ],
                  ),
                ),
                if (data.promoProduct.isPromo)
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      minTileHeight: 0,
                      childrenPadding: const EdgeInsets.only(
                        left: 5,
                        right: 12,
                        bottom: 12,
                      ),
                      title: const Text(
                        "Detail Promo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _infoCard("Promo Type", data.promoProduct.promoType ?? "-"),
                              _infoCard("Promo Price", data.promoProduct.promoPrice != null ? rupiah(data.promoProduct.promoPrice!) : "-"),
                              _infoCard("Start", formatDate2(data.promoProduct.startDate)),
                              _infoCard("End", formatDate2(data.promoProduct.endDate)),
                              _infoCard("Promo Scope", data.promoProduct.promoScope.toString()),
                              _infoCard("Used Qty", data.promoProduct.usedQty?.toString() ?? "-"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                if (hasCapitalCTA)
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      minTileHeight: 0,
                      childrenPadding: const EdgeInsets.only(
                        left: 5,
                        right: 12,
                        bottom: 12,
                      ),
                      title: const Text(
                        "Inventory Capital",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.orange.withOpacity(.25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// HEADER
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: 20,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Capital Exposure",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              /// HERO NUMBER
                              Text(
                                rupiah(data.ctaCapital?.idleCapital ?? 0),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Estimated capital tied up in inventory",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Expanded(
                                    child: _infoCard(
                                      "Coverage",
                                      "${data.ctaCapital?.coverageDay ?? 0} Days",
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            size: 18,
                                            color: Colors.orange,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "FREE UP CAPITAL",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    minTileHeight: 0,
                    childrenPadding: const EdgeInsets.only(
                      left: 5,
                      right: 12,
                      bottom: 12,
                    ),
                    title: const Text(
                      "Recommended Actions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: actions.map((action) {
                            return ElevatedButton.icon(
                              onPressed: () {
                                if (action.type == "PROMO") {
                                  onCreatePromo?.call();
                                } else if (action.type == "RESTOCK") {
                                  onRestock?.call();
                                } else if (action.type == "CAMPAIGN") {
                                  onCampaignPush?.call();
                                }
                              },
                              icon: Icon(getCTAIcon(action.type)),
                              label: Text(action.label),
                            );
                          }).toList(),
                        ),
                      ),
                      if (actions.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "No immediate action required.",
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData getCTAIcon(String type) {
    switch (type) {
      case "PROMO":
        return Icons.local_offer;

      case "RESTOCK":
        return Icons.inventory_2;

      case "CAMPAIGN":
        return Icons.campaign;

      default:
        return Icons.info;
    }
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

  Widget _infoCard(String label, String value) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 140,
        maxWidth: 180,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String normalizeNetto(String netto) {
    return netto.toLowerCase().replaceAll(RegExp(r'\s+'), '').replaceAll('gram', 'g').replaceAll('gr', 'g').replaceAll('ml.', 'ml');
  }
}
