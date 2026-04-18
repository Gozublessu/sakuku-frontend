import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/core/chart_range.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';
import 'package:sakuku_desktop/providers/product_insight_provider.dart';
import 'dart:async';
import 'package:sakuku_desktop/utils/hover_wrapper.dart';
import 'package:sakuku_desktop/widgets/premium_tooltip.dart';

class TopTierCard extends StatefulWidget {
  const TopTierCard({super.key});

  @override
  State<TopTierCard> createState() => _TopTierCardState();
}

class _TopTierCardState extends State<TopTierCard> {
  late PageController controller;
  Timer? timer;
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<TierListProvider>();
    controller = PageController(initialPage: provider.currentPage);

    startAutoSlide();
  }

  void startAutoSlide() {
    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) {
        final provider = context.read<TierListProvider>();

        if (isHovering || provider.hasInsightOpen) return;

        int nextPage = provider.currentPage + 1;

        if (nextPage > 3) nextPage = 0;

        controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TierListProvider>();
    final items = provider.tierlist;

    final subtitles = [
      "Penjualan terbaik hari ini.",
      "Penjualan terbaik 7 hari terakhir.",
      "Penjualan terbaik 30 hari terakhir.",
      "Penjualan terbaik sepanjang waktu.",
    ];

    return MouseRegion(
      onEnter: (_) {
        isHovering = true;
        timer?.cancel();
      },
      onExit: (_) {
        isHovering = false;
        startAutoSlide();
      },
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(18),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                subtitles[provider.currentPage],
                key: ValueKey(provider.currentPage),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 140,
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: controller,
                onPageChanged: (index) {
                  context.read<TierListProvider>().setPage(index);
                },
                children: [
                  _buildTierList(context, TierRange.today),
                  _buildTierList(context, TierRange.week),
                  _buildTierList(context, TierRange.month),
                  _buildTierList(context, TierRange.all),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isActive = provider.currentPage == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 12 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF2F89FF) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            if (items.isEmpty) const Text("Belum ada data")
          ],
        ),
      ),
    );
  }

  Widget _buildTierList(BuildContext context, TierRange range) {
    final provider = context.watch<TierListProvider>();
    final items = provider.tierlist;
    final topItems = items.take(3).toList();

    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Belum ada data"),
        ),
      );
    }

    return Column(
      children: List.generate(topItems.length, (index) {
        final item = topItems[index];
        final isActive = provider.selectedIndex == index;

        return Column(
          children: [
            PremiumTooltip(
              message: "Klik untuk melihat detail.",
              TextColor: Colors.black,
              child: HoverWrapper(
                scale: 1.02,
                child: InkWell(
                  onTap: () {
                    final tierProvider = context.read<TierListProvider>();
                    final insightProvider = context.read<ProductInsightProvider>();

                    if (tierProvider.selectedIndex == index) {
                      tierProvider.toggleIndex(index);
                      insightProvider.clearInsight();
                    } else {
                      tierProvider.toggleIndex(index);
                      insightProvider.loadInsight(
                        productId: item.productId,
                        rank: index + 1,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFFE8F2FF) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "#${index + 1}",
                          style: const TextStyle(
                            fontSize: 12,
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
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        "${item.totalQty} pcs",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            /// 🔥 PROGRESS BAR
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: item.totalQty / topItems.first.totalQty,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: const Color(0xFF2F89FF),
              ),
            ),
            if (index < topItems.length - 1) const SizedBox(height: 2),
          ],
        );
      }),
    );
  }
}
