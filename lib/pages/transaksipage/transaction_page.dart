import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/pages/transaksipage/widgets/summary_daily.dart';
import 'package:sakuku_desktop/pages/transaksipage/widgets/transaction_list.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';
import 'package:sakuku_desktop/providers/transactionListProvider.dart';
import 'widgets/card_insight.dart';
import 'widgets/top_tier_card.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final ScrollController _controller = ScrollController();
  List<bool> expanded = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitial();
      context.read<TierListProvider>().initAll();
    });

    _controller.addListener(() {
      final provider = context.read<TransactionListProvider>();

      if (!provider.hasMore || provider.isPaging) return;

      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        provider.loadNextPage();
      }
    });
  }

  Future<void> loadInitial() async {
    final provider = context.read<TransactionListProvider>();

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

          // =========================
          // 🔻 SMALL MODE (VERTICAL)
          // =========================
          if (isSmall) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),

                  // 🔥 SUMMARY + TOP TIER (tetap ada, tapi turun)
                  _buildTopSection(isFiltered),

                  const SizedBox(height: 20),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 600,
                    child: TransactionList(
                      controller: _controller,
                      transactions: transactions,
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

          // =========================
          // 🔺 BIG MODE (DASHBOARD)
          // =========================
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 920,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: _buildTopSection(isFiltered),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 450,
                            child: buildCardIsight(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: SizedBox(
                        height: 710,
                        child: TransactionList(
                          controller: _controller,
                          transactions: transactions,
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Transaction",
          style: TextStyle(
            color: Color(0xFF147BF7),
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Overview daily transactions",
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTopSection(bool isFiltered) {
    return SizedBox(
      height: 250,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 380,
            child: SummaryCard(
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
          ),
          const SizedBox(width: 15),
          const SizedBox(
            width: 350,
            child: TopTierCard(),
          ),
        ],
      ),
    );
  }

  Widget buildCardIsight() {
    return Container(
      width: 980,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      child: CardDeepInsight(),
    );
  }
}
