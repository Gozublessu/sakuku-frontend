import 'package:flutter/material.dart';

class PromoHeader extends StatelessWidget {
  final VoidCallback onBack;

  final String productName;

  final String netto;
  final String title;

  const PromoHeader({
    super.key,
    required this.onBack,
    required this.productName,
    required this.netto,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(
            Icons.arrow_back,
          ),
          label: const Text(
            "Back to Insight",
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "$productName $netto",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
