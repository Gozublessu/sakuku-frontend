import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/models/summary_model.dart';
import 'package:sakuku_desktop/providers/transactionListProvider.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionListProvider>();
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterdayStr = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
    // print("Today: $todayStr");
    // print("Yesterday: $yesterdayStr");
    // for (final e in provider.dailySummary) {
    //   print("Summary: ${e.date} -> ${e.totalPenjualan}");
    // }

    final today = provider.dailySummary.firstWhere(
      (e) => e.date == todayStr,
      orElse: () => SummaryModel.empty(todayStr),
    );

    final yesterday = provider.dailySummary.firstWhere(
      (e) => e.date == yesterdayStr,
      orElse: () => SummaryModel.empty(yesterdayStr),
    );
    final hasYesterdayTransaction = yesterday.totalPenjualan > 0;

    double growth = 0;
    if (hasYesterdayTransaction) {
      growth = ((today.totalPenjualan - yesterday.totalPenjualan) / yesterday.totalPenjualan) * 100;
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2F89FF),
            Color(0xFF5AA9FF)
          ],
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),

          // BIG NUMBER
          Text(
            rupiah(today.totalPenjualan),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // _buildMiniStat("Profit", rupiah(summary.totalProfit), Colors.greenAccent),
              _buildMiniStatWithTrend(
                "Profit",
                today.totalProfit,
                growth,
                hasYesterdayTransaction,
              ),
              _buildMiniStat("Transaksi", today.jumlahTransaksi.toString(), Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today Overview",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('dd MMM yyyy').format(DateTime.now()),
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildMiniStatWithTrend(String label, num value, double growth, bool hasYesterdayTransaction) {
    final isPositive = growth >= 0;

    final String growthText = hasYesterdayTransaction ? "${growth.toStringAsFixed(1)}% from yesterday" : "No transaction yesterday";

    final Color growthColor = hasYesterdayTransaction ? (isPositive ? Colors.greenAccent : Colors.yellow) : Colors.white54;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),

        // ICON + ANGKA (SEJAJAR)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: isPositive ? Colors.greenAccent : Colors.yellow,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              rupiah(value),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isPositive ? Colors.greenAccent : Colors.yellow,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // GROWTH
        Text(
          growthText,
          style: TextStyle(
            color: growthColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
