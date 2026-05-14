import 'package:flutter/material.dart';

class PromoResultSection extends StatelessWidget {
  final String newPrice;
  final String newMargin;
  final int selectedQty;
  final String profitStatus;
  final Color statusColor;

  const PromoResultSection({
    super.key,
    required this.newPrice,
    required this.newMargin,
    required this.selectedQty,
    required this.profitStatus,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _promoStatCard(
            "New Price",
            newPrice,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _promoStatCard(
            "New Margin",
            newMargin,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _promoStatCard(
            "Promo Qty",
            "$selectedQty Pcs",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Profit Status",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profitStatus,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _promoStatCard(
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
