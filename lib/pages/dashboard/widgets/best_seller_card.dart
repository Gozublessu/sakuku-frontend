import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';
import 'package:sakuku_desktop/utils/hover_wrapper.dart';

class BestSellerCard extends StatelessWidget {
  const BestSellerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TierListProvider>();
    final items = provider.tierlist;
    final topItems = items.take(3).toList();

    final totalTodayQty = topItems.fold<int>(
      0,
      (sum, items) => sum + items.totalQty,
    );

    return Container(
      height: 250,
      width: 450,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Color(0xFF2F89FF),
            Color(0xFF5AA9FF),
          ],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Best Seller Today",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Produk dengan penjualan tertinggi hari ini",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          if (provider.isLoading)
            const Text(
              "Loading...",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          if (!provider.isLoading && items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  "Belum ada Produk terjual hari ini",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ...List.generate(topItems.length, (index) {
            final item = topItems[index];
            final percentage = totalTodayQty > 0 ? (item.totalQty / totalTodayQty) * 100 : 0;

            return Column(
              children: [
                HoverWrapper(
                  scale: 1.05,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.namaProduk,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "${item.totalQty}pcs",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        "${percentage.toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: item.totalQty / topItems.first.totalQty,
                    minHeight: 6,
                    backgroundColor: Colors.grey,
                    color: Colors.white,
                  ),
                ),
                if (index < topItems.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
