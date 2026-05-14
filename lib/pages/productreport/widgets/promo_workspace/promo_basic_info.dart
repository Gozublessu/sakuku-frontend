import 'package:flutter/material.dart';

class PromoBasicInfo extends StatelessWidget {
  final String buyPrice;

  final String sellPrice;

  final String margin;

  final String stock;

  final Widget statCard;

  const PromoBasicInfo({
    super.key,
    required this.buyPrice,
    required this.sellPrice,
    required this.margin,
    required this.stock,
    required this.statCard,
  });

  Widget _buildCard(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Info Basic Product",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                "Buy Price",
                buyPrice,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                "Sell Price",
                sellPrice,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                "Current Margin",
                margin,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                "Stock Ready",
                stock,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
