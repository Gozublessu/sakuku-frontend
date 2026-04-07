import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';
import 'package:sakuku_desktop/providers/product_insight_provider.dart';
import 'package:sakuku_desktop/utils/hover_wrapper.dart';
import 'package:sakuku_desktop/widgets/premium_tooltip.dart';

class TopTierCard extends StatelessWidget {
  const TopTierCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TierListProvider>();
    final items = provider.tierlist;
    final topItems = items.take(5).toList();

    return Container(
      width: 450,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Produk Terlaris",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Akumulasi produk terlaris dalam 30 hari terakhir",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (provider.isLoading) const Text("Loading..."),
          if (!provider.isLoading && items.isEmpty) const Text("Belum ada data"),
          ...List.generate(topItems.length, (index) {
            final item = topItems[index];

            return PremiumTooltip(
              message: "Klik untuk detail",
              tooltipColor: const Color(0xFF2F89FF),
              TextColor: Colors.black,
              child: HoverWrapper(
                scale: 1.05,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<ProductInsightProvider>().loadInsight(
                              productId: item.productId,
                              rank: index + 1,
                            );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F2FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "#${index + 1}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF287BFF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.namaProduk,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "${item.totalQty} pcs",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < topItems.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
