import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';
import '../pages/test_helper_page.dart';
import '../providers/summary_provider.dart';
import 'package:provider/provider.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class AllTimePiePlaceholder extends StatelessWidget {
  final String title;
  const AllTimePiePlaceholder({
    super.key,
    this.title = "Modal Composition Overview",
  });
  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<SummaryProvider>(context);
    if (summaryProvider.allTimeSummary == null) {
      Future.microtask(() => summaryProvider.loadAllTime());
    }

    final all = summaryProvider.allTimeSummary!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),
          // sanitize values

          // PIE
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    color: Colors.blue.shade400,
                    value: (all['modal_awal'] as num).toDouble(),
                    title: '',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    color: Colors.green.shade400,
                    value: (all['total_modal_transaksi'] as num).toDouble(),
                    title: '',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    color: Colors.red.shade400,
                    value: (all['profit_after_initial'] as num).abs().toDouble(),
                    title: '',
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // LEGEND
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _LegendDot(color: Colors.blue, label: "Modal keluar"),
              _LegendDot(color: Colors.green, label: "Modal masuk"),
              _LegendDot(color: Colors.red, label: "Modal tertahan"),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        )
      ],
    );
  }
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<SummaryProvider>(context);
    if (summaryProvider.allTimeSummary == null) {
      Future.microtask(() => summaryProvider.loadAllTime());
      return const Center(child: CircularProgressIndicator());
    }
    final provider = context.watch<SummaryProvider>();
    final chart = provider.chartData;

    final period = summaryProvider.periodSummary;
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                const Text(
                  "Financial Summary",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Overview of your business performance",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 24),

                // ALL TIME
                _sectionHeader("All Time Summary"),
                const SizedBox(height: 12),

                LayoutBuilder(
                  builder: (context, c) {
                    return _grid(c.maxWidth, summaryProvider.allTimeSummary!, allTimeMap);
                  },
                ),
                const SizedBox(height: 20),

                //   ADD PIE
                const AllTimePiePlaceholder(),

                const SizedBox(height: 30),

                // PERIOD
                Row(
                  children: [
                    _sectionHeader("Periode Summary"),
                    const Spacer(),
                    _resetButton(),
                    const SizedBox(width: 10),
                    _dateButton("Start", isStart: true),
                    const SizedBox(width: 10),
                    _dateButton("End", isStart: false),
                  ],
                ),

                const SizedBox(height: 12),
                if (period != null)
                  LayoutBuilder(
                    builder: (context, c) {
                      return _grid(
                        c.maxWidth,
                        summaryProvider.periodSummary ?? {},
                        periodMap,
                      );
                    },
                  ),

                const SizedBox(height: 30),

                // CHART AREA
                Container(
                  height: 380,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: chart.isEmpty
                      ? Center(
                          child: Text(
                            "Pilih rentang tanggal untuk menampilkan chart",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        )
                      : (() {
                          // ==============================
                          // VALUE RANGE
                          // ==============================
                          final maxValue = chart.map((e) => e.penjualan).reduce((a, b) => a > b ? a : b);
                          final margin = maxValue * 0.25;
                          final minY = 0.0;
                          final maxY = maxValue + margin;

                          // ==============================
                          // FORMATTER
                          // ==============================
                          String formatValue(double value) {
                            if (value >= 1e9) return "${(value / 1e9).toStringAsFixed(1)}B";
                            if (value >= 1e6) return "${(value / 1e6).toStringAsFixed(0)}jt";
                            if (value >= 1e3) return "${(value / 1e3).toStringAsFixed(0)}K";
                            return value.toStringAsFixed(0);
                          }

                          final xMargin = 0.3;

                          return LineChart(
                            LineChartData(
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  fitInsideHorizontally: true,
                                  fitInsideVertically: true,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      return LineTooltipItem(
                                        rupiah(spot.y), // Format Rupiah masuk sini
                                        const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              minX: -xMargin,
                              maxX: (chart.length - 1).toDouble() + xMargin,
                              minY: minY,
                              maxY: maxY,

                              // biar chart bener2 stay in-frame
                              clipData: const FlClipData(
                                left: false,
                                right: false,
                                top: true,
                                bottom: true,
                              ),
                              borderData: FlBorderData(show: false),

                              // ==============================
                              // GRID
                              // ==============================
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: (maxValue / 4).clamp(1, double.infinity),
                                getDrawingHorizontalLine: (_) => FlLine(
                                  color: Colors.black.withOpacity(0.08),
                                  strokeWidth: 1,
                                ),
                              ),

                              // ==============================
                              // TITLES
                              // ==============================
                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    reservedSize: 26, // biar ga dempet bawah
                                    getTitlesWidget: (value, meta) {
                                      if (value % 1 != 0) return const SizedBox.shrink();
                                      final i = value.toInt();
                                      if (i < 0 || i >= chart.length) return const SizedBox.shrink();

                                      final d = chart[i].date;
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}",
                                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 26, // bikin napas kiri lega
                                    interval: (maxValue / 4).clamp(1, double.infinity),
                                    getTitlesWidget: (v, meta) => Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: Text(
                                        formatValue(v),
                                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // ==============================
                              // LINE
                              // ==============================
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  curveSmoothness: 0.25,
                                  barWidth: 3,
                                  color: const Color(0xFF2D8CFF),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFF2D8CFF).withOpacity(0.25),
                                        Colors.blue.withOpacity(0.03),
                                      ],
                                    ),
                                  ),
                                  dotData: FlDotData(show: false),
                                  spots: List.generate(
                                    chart.length,
                                    (i) => FlSpot(
                                      i.toDouble(),
                                      chart[i].penjualan.toDouble(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resetButton() {
    final provider = Provider.of<SummaryProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        provider.setStart(null);
        provider.setEnd(null);
        provider.clearPeriod();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            )
          ],
        ),
        child: const Text(
          "Reset",
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // SECTION TITLE + LINE TIPIS
  Widget _sectionHeader(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // RESPONSIVE GRID
  Widget _grid(double width, Map<String, dynamic> data, Map<String, String> fieldMap) {
    int count = 5;

    if (width < 900) count = 3;
    if (width < 650) count = 2;
    if (width < 400) count = 1;

    const nonRupiahFields = {
      "jumlah_transaksi"
    };

    return GridView.count(
      crossAxisCount: count,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 2.8,
      children: fieldMap.entries.map((e) {
        final field = e.value;
        final rawValue = data[field] ?? 0;

        final value = nonRupiahFields.contains(field) ? rawValue.toString() : rupiah(rawValue);

        return _smallCard(e.key, value);
      }).toList(),
    );
  }

  // CARD DENGAN HOVER
  Widget _smallCard(String title, String value) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateButton(String text, {required bool isStart}) {
    final provider = context.watch<SummaryProvider>();
    final selectedDate = isStart ? provider.selectedStart : provider.selectedEnd;
    final displayDate = selectedDate == null ? '-' : selectedDate.toString().split(' ')[0];

    final isSelected = selectedDate != null;

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          if (isStart) {
            provider.setStart(picked);
          } else {
            provider.setEnd(picked);
          }

          // Jika dua tanggal lengkap -> load period
          if (provider.selectedStart != null && provider.selectedEnd != null) {
            Provider.of<SummaryProvider>(context, listen: false).loadPeriod();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: isSelected ? Colors.blue : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              "$text: $displayDate",
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
