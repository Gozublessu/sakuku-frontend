import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';

class BestSellerCard extends StatefulWidget {
  const BestSellerCard({super.key});

  @override
  State<BestSellerCard> createState() => _BestSellerCardState();
}

class _BestSellerCardState extends State<BestSellerCard> {
  int currentIndex = 0;
  bool isAnimating = false;

  Timer? sliderTimer;
  @override
  void initState() {
    super.initState();

    sliderTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        final provider = context.read<TierListProvider>();

        final items = provider.tierlist;

        if (items.isEmpty) return;

        /// 🔥 mulai anim keluar
        setState(() {
          isAnimating = true;
        });

        /// 🔥 tunggu fade out
        Future.delayed(
          const Duration(milliseconds: 300),
          () {
            if (!mounted) return;

            setState(() {
              /// 🔥 ganti item
              currentIndex = (currentIndex + 1) % items.take(3).length;

              /// 🔥 anim masuk
              isAnimating = false;
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    sliderTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TierListProvider>();
    final items = provider.tierlist;
    final topItems = items.take(3).toList();

    if (topItems.isEmpty) {
      return Container(
        height: 250,
        width: 450,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3B82F6),
              Color(0xFF2563EB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Text(
              "Today's Market",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),
            Text(
              "No transactions yet today",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }
    final topItem = topItems[currentIndex];

    final totalTodayQty = items.fold<int>(
      0,
      (sum, items) => sum + items.totalQty,
    );

    final topPercentage = totalTodayQty == 0 ? 0 : (topItem.totalQty / totalTodayQty) * 100;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF2563EB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Text(
            "Today's Market",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "${provider.totalSoldSku} active SKU • ${provider.totalQtySold} units moved",
            style: TextStyle(
              color: Colors.white.withOpacity(.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          /// HERO
          Center(
            child: Column(
              children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic,
                  offset: isAnimating ? const Offset(0, .08) : Offset.zero,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: isAnimating ? 0 : 1,
                    child: Column(
                      key: ValueKey(topItem.productId),
                      children: [
                        Text(
                          "${topPercentage.toStringAsFixed(1)}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Top Market Share",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          topItem.namaProduk,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${topItem.totalQty} pcs moved today",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Leading today's movement",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
