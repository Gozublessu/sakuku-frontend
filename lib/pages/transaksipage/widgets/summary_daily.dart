import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';
import 'package:sakuku_desktop/providers/transactionListProvider.dart';
import 'package:sakuku_desktop/models/summary_model.dart';

class SummaryCard extends StatelessWidget {
  final DateTime selectedDate;
  final bool isFiltered;
  final VoidCallback onPickDate;
  final VoidCallback onResetFilter;

  const SummaryCard({
    super.key,
    required this.selectedDate,
    required this.isFiltered,
    required this.onPickDate,
    required this.onResetFilter,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionListProvider>();

    final selectedDateStr = DateFormat("yyyy-MM-dd").format(selectedDate);

    final summary = provider.dailySummary.firstWhere(
      (e) => e.date == selectedDateStr,
      orElse: () => SummaryModel(
        date: selectedDateStr,
        totalPenjualan: 0,
        totalModal: 0,
        totalProfit: 0,
        jumlahTransaksi: 0,
      ),
    );

    return Container(
      width: 450,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // color: isFiltered ? Colors.orange.withOpacity(0.9) : const Color(0xFF2F89FF).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isFiltered
              ? [
                  Colors.purpleAccent,
                  Colors.deepPurpleAccent,
                  // Colors.orange.withOpacity(0.9),
                  // Colors.deepOrangeAccent.withOpacity(0.9),
                ]
              : [
                  Color(0xFF2F89FF),
                  Color(0xFF2F89FF),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryHeader(isFiltered),
              _buildSummaryButtons(isFiltered),
            ],
          ),

          const SizedBox(height: 25),

          _buildSummaryValue(
            "Total Transaksi",
            summary.jumlahTransaksi,
            useRupiah: false,
          ),
          const SizedBox(height: 10),
          _buildSummaryValue(
            "Total Penjualan",
            summary.totalPenjualan,
          ),
          const SizedBox(height: 10),
          _buildSummaryValue(
            "Total Modal",
            summary.totalModal,
          ),
          const SizedBox(height: 10),
          _buildSummaryValue(
            "Total Profit",
            summary.totalProfit,
            isProfit: true,
          ),
        ],
      ),
    );
  }

  // =========================
  // PRIVATE HELPERS
  // =========================

  Widget _buildSummaryHeader(bool isFiltered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Summary Daily",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isFiltered ? "Filter aktif (${DateFormat('dd MMM yyyy').format(selectedDate)})" : "Tanggal: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSummaryButtons(bool isFiltered) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: onPickDate,
          icon: const Icon(Icons.filter_alt, size: 18),
          label: const Text("Filter"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        if (isFiltered) ...[
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: onResetFilter,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Reset"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryValue(String label, num value, {bool isProfit = false, bool useRupiah = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(
          useRupiah ? rupiah(value) : value.toString(),
          style: TextStyle(
            color: isProfit ? Colors.greenAccent : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
