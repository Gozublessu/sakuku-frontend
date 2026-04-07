import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/pages/transaksipage/widgets/summary_daily.dart';
import 'package:sakuku_desktop/pages/transaksipage/widgets/transaction_list.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';
import 'package:sakuku_desktop/providers/transactionListProvider.dart';
import 'widgets/card_insight.dart';
import 'widgets/top_tier_card.dart';
import 'package:sakuku_desktop/core/chart_range.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final ScrollController _controller = ScrollController();
  List<bool> expanded = [];
  DateTime selectedDate = DateTime.now();
  // ChartRange _range = ChartRange.month;
  final _range = ChartRange.month;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitial();
    });

    _controller.addListener(() {
      final provider = context.read<TransactionListProvider>();

      if (!provider.hasMore || provider.isPaging) return;

      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        provider.loadNextPage();
      }
      // print("pixels=${_controller.position.pixels}, max=${_controller.position.maxScrollExtent}");
    });
  }

  Future<void> loadInitial() async {
    final provider = context.read<TransactionListProvider>();
    final providerTierList = context.read<TierListProvider>();

    await providerTierList.loadByRange(_range);

    // load summary
    await provider.loadDailySummary(
      selectedDate,
      selectedDate,
    );

    // load list awal
    await provider.loadInitial();

    if (mounted) {
      setState(() {
        expanded = List<bool>.filled(provider.transactions.length, false);
      });
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    final provider = context.read<TransactionListProvider>();

    await provider.loadDailySummary(picked, picked);

    _controller.jumpTo(0);

    await provider.resetAndLoad(filteredDate: picked);

    if (!mounted) return;
    setState(() {
      selectedDate = picked;
      expanded = List<bool>.filled(provider.transactions.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionListProvider>();

    final isFiltered = provider.filterDate != null;

    final transactions = provider.transactions;

    if (expanded.length != transactions.length) {
      expanded = List<bool>.filled(transactions.length, false);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 1250;

          if (isSmall) {
            // MODE SEMPT — disusun VERTIKAL supaya gak overflow
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeftPanel(isFiltered),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CardDeepInsight(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 600, // biar ListView bisa scroll
                    child: TransactionList(
                      controller: _controller,
                      transactions: provider.transactions,
                      expanded: expanded,
                      hasMore: provider.hasMore,
                      onLoadMore: provider.loadNextPage,
                      onToggle: (index) {
                        setState(() {
                          expanded[index] = !expanded[index];
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          // MODE BESAR — layout normal Row
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLeftPanel(isFiltered),
                const SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: SizedBox(
                    width: 455,
                    child: CardDeepInsight(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: TransactionList(
                      controller: _controller,
                      transactions: provider.transactions,
                      expanded: expanded,
                      hasMore: provider.hasMore,
                      onLoadMore: provider.loadNextPage,
                      onToggle: (index) {
                        setState(() {
                          expanded[index] = !expanded[index];
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeftPanel(bool isFiltered) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          const Text(
            "Transaction",
            style: TextStyle(
              color: Color(0xFF147BF7),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),
          const Text(
            "Overview daily transactions",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),

          const SizedBox(height: 28),

          // SUMMARY CARD
          SummaryCard(
            selectedDate: selectedDate,
            isFiltered: isFiltered,
            onPickDate: pickDate,
            onResetFilter: () async {
              final now = DateTime.now();
              final provider = context.read<TransactionListProvider>();

              provider.filterDate = null;
              setState(() => selectedDate = now);

              await provider.resetAndLoad();
              await provider.loadDailySummary(now, now);
            },
          ),

          const SizedBox(height: 15),

          // TOP TIER PRODUK
          const TopTierCard(),
        ],
      ),
    );
  }
}
