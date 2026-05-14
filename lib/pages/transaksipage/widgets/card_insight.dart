import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/models/insight_produk_model.dart';
import '../../../providers/product_insight_provider.dart';
import '../../../utils/helper_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sakuku_desktop/core/chart_range.dart';

class CardDeepInsight extends StatefulWidget {
  const CardDeepInsight({super.key});

  @override
  State<CardDeepInsight> createState() => _CardDeepInsightState();
}

class _CardDeepInsightState extends State<CardDeepInsight> {
  final ScrollController _scrollCtrl = ScrollController();
  ChartRange _range = ChartRange.month;

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductInsightProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Container(
            height: 380,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(color: Colors.blue),
          );
        }

        final data = provider.insight;

        if (data == null) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insights_outlined,
                size: 50,
                color: Colors.blue,
              ),
              Text(
                "Pilih produk dahulu",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }

        return Container(
          // height: 800,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFF2F89FF),
            // gradient: const LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     Color(0xFF2F89FF),
            //     Colors.purpleAccent,
            //   ],
            // ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildScrollableContent(data, provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScrollableContent(dynamic data, provider) {
    final aggregated = context.watch<ProductInsightProvider>().aggregatedDailySales;
    final filteredSales = filterAggregated(aggregated, _range);

    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0.25),
        ),
      ),
      child: Scrollbar(
        controller: _scrollCtrl,
        thumbVisibility: false,
        child: SingleChildScrollView(
            controller: _scrollCtrl,
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Insight Top Produk",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                _heroHeader(
                  productName: data.product.nama,
                  totalQty: data.summary.totalQty,
                  totalProfit: data.summary.totalProfit,
                  rank: provider.selectedRank,
                ),

                const SizedBox(height: 16),

                _performanceSnapshot(
                  totalSales: data.summary.totalJual,
                  firstSold: data.summary.firstSold,
                  peakQty: data.peakDay.qty,
                  peakDate: data.peakDay.date,
                ),

                const SizedBox(height: 16),

                _performanceStatus(data), // 🔥 NEW

                const SizedBox(height: 20),

                _rangeSelector(),
                const SizedBox(height: 12),

                _chartSales(dailySales: filteredSales),

                const SizedBox(height: 20),

                _sectionHeader("Informasi Produk"),
                _infoGrid([
                  _infoItem("Kategori", data.product.kategori, Icons.category),
                  _infoItem("Netto", data.product.netto, Icons.label),
                  _infoItem("Harga Beli", rupiah(data.product.hargaBeli), Icons.sell),
                  _infoItem("Harga Jual", rupiah(data.product.hargaJual), Icons.sell_outlined),
                  _infoItem("Masuk", formatDate2(data.product.dateIn), Icons.calendar_today),
                  _infoItem("Margin", rupiah(data.product.marginRp), Icons.margin),
                ]),

                const SizedBox(height: 20),

                _sectionHeader("Informasi Stok"),
                _infoGrid([
                  _infoItem("Total Masuk", "${data.product.totalStokMasuk}", Icons.inventory_2),
                  _infoItem("Sisa Stok", "${data.product.stok}", Icons.inventory),
                ]),

                const SizedBox(height: 20),

                _restockInsightBox(data.restockHistory),
              ],
            )),
      ),
    );
  }

  List<MapEntry<DateTime, int>> filterAggregated(
    List<MapEntry<DateTime, int>> source,
    ChartRange range,
  ) {
    if (source.isEmpty) return [];

    switch (range) {
      case ChartRange.week:
        return source.length <= 7 ? source : source.sublist(source.length - 7);

      case ChartRange.month:
        return source.length <= 30 ? source : source.sublist(source.length - 30);

      case ChartRange.all:
        return source;
    }
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white60,
        ),
      ),
    );
  }

  Widget _restockInsightBox(List<RestockHistory> history) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Restock Insight",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...history.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    e.isInitial ? Icons.flag : Icons.add_circle_outline,
                    size: 18,
                    color: e.isInitial ? Colors.blue : Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDate2(e.date),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Qty ${e.qty} || ${e.isInitial ? "Stok Awal" : "Restock"}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _heroHeader({
    required String productName,
    required num totalQty,
    required num totalProfit,
    int? rank,
  }) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Color(0xFF2F89FF),
                Colors.deepPurpleAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              // Product name + TOP badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _topProductBadge(),
                ],
              ),

              const SizedBox(height: 16),

              // Big sold number
              Text(
                "$totalQty pcs",
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              // Profit
              Text(
                "${rupiah(totalProfit)} profit",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),

        // RANK — FLOATING, GEDE, PRESTIGE
        if (rank != null)
          Positioned(
            right: 16,
            bottom: 16,
            child: _rankBadge(rank),
          ),
      ],
    );
  }

  Widget _rankBadge(int rank) {
    final color = switch (rank) {
      1 => Colors.amber.shade400,
      2 => Colors.grey,
      3 => Colors.brown,
      _ => Colors.blue,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black26,
        //     blurRadius: 6,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      child: Text(
        "#$rank",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _topProductBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "🔥 TOP",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _performanceSnapshot({
    required double totalSales,
    required DateTime firstSold,
    required int peakQty,
    required DateTime peakDate,
  }) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _SnapshotItem(
            icon: Icons.receipt_long,
            label: "Total Sales",
            value: rupiah(totalSales),
          ),
          _SnapshotItem(
            icon: Icons.calendar_today,
            label: "First Sold",
            value: formatDate2(firstSold),
          ),
          _SnapshotItem(
            icon: Icons.trending_up,
            label: "Peak Day",
            value: "${formatDate2(peakDate)} || $peakQty pcs",
          ),
        ],
      ),
    );
  }

  Widget _rangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: ChartRange.values.map((range) {
            final isActive = _range == range;

            return InkWell(
              onTap: () {
                if (_range == range) return;
                setState(() => _range = range);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white.withOpacity(0.25) : Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  range == ChartRange.week
                      ? '7Day'
                      : range == ChartRange.month
                          ? '30Day'
                          : 'ALL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Text(
          "chart berdasarkan hari terakhir",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _chartSales({
    required List<MapEntry<DateTime, int>> dailySales,
  }) {
    if (dailySales.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("No data")),
      );
    }

    final spots = <FlSpot>[];

    for (int i = 0; i < dailySales.length; i++) {
      spots.add(
        FlSpot(
          i.toDouble(),
          dailySales[i].value.toDouble(), // qty
        ),
      );
    }

    final maxQty = dailySales.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();

    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (dailySales.length - 1).toDouble(),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // 🔥 LABEL BAWAH (SUDAH GA KERITING)
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();

                    if (index < 0 || index >= dailySales.length) {
                      return const SizedBox();
                    }

                    // 🔥 kontrol jumlah label
                    final step = (dailySales.length / 6).ceil();

                    if (index % step != 0) {
                      return const SizedBox();
                    }

                    final date = dailySales[index].key;

                    return Text(
                      DateFormat('dd MMM').format(date),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 1.3,
                preventCurveOverShooting: true,
                color: Colors.white,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) {
                    final isPeak = spot.y == maxQty;

                    return FlDotCirclePainter(
                      radius: isPeak ? 6 : 3,
                      color: isPeak ? Colors.greenAccent : Colors.white,
                      strokeWidth: 0,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.toInt()} pcs',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _performanceStatus(dynamic data) {
    final movement = data.narrative.summary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insights_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              movement,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoGrid(List<Widget> items) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.8,
      children: items,
    );
  }

  Widget _infoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SnapshotItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SnapshotItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
