import 'package:flutter/material.dart';

class PromoScopeSection extends StatelessWidget {
  final bool applyAllStock;

  final TextEditingController promoQtyController;

  final VoidCallback onAllStock;

  final VoidCallback onCustomQty;

  final VoidCallback onQtyChanged;

  const PromoScopeSection({
    super.key,
    required this.applyAllStock,
    required this.promoQtyController,
    required this.onAllStock,
    required this.onCustomQty,
    required this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Promo Scope",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ChoiceChip(
              label: const Text(
                "All Stock",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              selected: applyAllStock,
              onSelected: (_) {
                onAllStock();
              },
            ),
            const SizedBox(width: 10),
            ChoiceChip(
              label: const Text(
                "Custom Qty",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              selected: !applyAllStock,
              onSelected: (_) {
                onCustomQty();
              },
            ),
          ],
        ),
        if (!applyAllStock) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 90,
              height: 40,
              child: TextField(
                controller: promoQtyController,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  onQtyChanged();
                },
                decoration: InputDecoration(
                  hintText: "Qty",
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          applyAllStock ? "Promo applies to all available stock" : "Promo only applies to selected quantity",
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
