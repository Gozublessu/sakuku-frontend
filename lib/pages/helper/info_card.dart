import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/insight_produk_model.dart';

class InfoCard extends StatelessWidget {
  final String value;
  final String label;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF2F89FF).withOpacity(0.08),
        border: Border.all(
          color: const Color(0xFF2F89FF).withOpacity(0.25),
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F89FF),
              ),
            ),
            TextSpan(
              text: "  $label ",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  final String text;

  const LoadingState({super.key, this.text = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

List<ChartPoint> build7DaysChart(List<DailySale> sales) {
  final now = DateTime.now();

  // 🔥 1. ambil 7 hari terakhir
  final last7Days = List.generate(7, (i) {
    final day = now.subtract(Duration(days: 6 - i));
    return DateTime(day.year, day.month, day.day);
  });

  // 🔥 2. group by tanggal
  final Map<DateTime, int> grouped = {};

  for (var sale in sales) {
    final date = DateTime(sale.date.year, sale.date.month, sale.date.day);

    grouped.update(date, (val) => val + sale.qty, ifAbsent: () => sale.qty);
  }

  // 🔥 3. build final list (isi 0 kalau ga ada)
  return last7Days.map((day) {
    return ChartPoint(
      day,
      grouped[day] ?? 0,
    );
  }).toList();
}

List<FlSpot> toSpots(List<ChartPoint> data) {
  return List.generate(data.length, (i) {
    return FlSpot(i.toDouble(), data[i].qty.toDouble());
  });
}

int findPeakIndex(List<ChartPoint> data, PeakDay peak) {
  if (peak.date == null) return -1;

  for (int i = 0; i < data.length; i++) {
    final d = data[i].date;
    if (d.year == peak.date!.year && d.month == peak.date!.month && d.day == peak.date!.day) {
      return i;
    }
  }
  return -1;
}

Widget buildSalesChart(
  List<DailySale> sales,
  double velocityShift,
) {
  final chartData = build7DaysChart(sales);
  final spots = toSpots(chartData);
  // print("🔥 velocityShift: $velocityShift");

  if (spots.isEmpty) {
    return SizedBox(
      height: 150,
      child: Center(child: Text("No data")),
    );
  }

  final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

  final isRising = velocityShift > 0.5;
  final lineColor = isRising ? Colors.green : Colors.yellow;

  return SizedBox(
    height: 150,
    child: LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const days = [
                  "Mon",
                  "Tue",
                  "Wed",
                  "Thu",
                  "Fri",
                  "Sat",
                  "Sun"
                ];
                return Text(
                  days[value.toInt() % 7],
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: lineColor,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) {
                return spot.y == maxY; // 🔥 peak doang
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withOpacity(0.4),
                  lineColor.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  "${spot.y.toInt()} pcs", // 🔥 INI FIX .0
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    ),
  );
}
