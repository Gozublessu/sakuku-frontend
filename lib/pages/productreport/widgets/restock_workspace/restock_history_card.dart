import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/insight_produk_model.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

class RestockHistoryCard extends StatelessWidget {
  final List<RestockHistory> histories;
  final num avgInterval;
  const RestockHistoryCard({
    required this.histories,
    required this.avgInterval,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.history,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "Recent Restock Activity",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...histories.take(5).take(5).toList().asMap().entries.map(
                (entry) => _timelineItem(
                  qty: entry.value.qty,
                  label: entry.value.isInitial
                      ? "Stock awal"
                      : formatDate2(
                          entry.value.date,
                        ),
                  isLast: entry.key == histories.take(5).length - 1,
                ),
              ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 18,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Average refill every  ${avgInterval.round()} days.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem({
    required int qty,
    required String label,
    required bool isLast,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 42,
                  color: Colors.grey,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "+$qty pcs",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
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
