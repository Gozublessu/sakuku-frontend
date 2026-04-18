import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/core/chart_range.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/best_seller_card.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/highlight_new_product.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/highlight_status.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/highlight_stock_card.dart';
import 'package:sakuku_desktop/pages/dashboard/widgets/summary_card.dart';
import 'package:sakuku_desktop/providers/low_stock_provider.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';
import 'package:sakuku_desktop/providers/transactionListProvider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    final provider = context.read<TransactionListProvider>();
    final providerTierList = context.read<TierListProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));

      providerTierList.loadForDashboard(TierRange.today);
      provider.loadDailySummary(yesterday, today);
    });
    Future.microtask(() {
      if (!mounted) return;
      dashboardProvider.fetchLowStock();
      dashboardProvider.fetchUpdate();
      dashboardProvider.getDeadStock();
      dashboardProvider.getNewProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardLeft(),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(top: 92),
            child: _buildCardMid(),
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(top: 92),
            child: HighlightStatus(),
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(top: 92),
            child: HighlightBestAlltime(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardLeft() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // titlepage
          const Text(
            "Dashboard",
            style: TextStyle(
              color: Color(0xFF147BF7),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Overview of your bussines",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 28),
          const SummaryCard(),
          const SizedBox(height: 15),
          BestSellerCard(),
        ],
      ),
    );
  }

  Widget _buildCardMid() {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          children: [
            StockLowCard(),
          ],
        ));
  }
}
