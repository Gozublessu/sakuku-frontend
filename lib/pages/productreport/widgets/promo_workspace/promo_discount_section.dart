import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

class PromoDiscountSection extends StatelessWidget {
  final TextEditingController discountController;

  final DateTime? promoStartDate;
  final DateTime? promoEndDate;

  final VoidCallback onPercentageSelected;

  final VoidCallback onNominalSelected;

  final VoidCallback onDiscountChanged;

  final VoidCallback onPickStartDate;

  final VoidCallback onPickEndDate;
  final DiscountType discountType;

  const PromoDiscountSection({
    super.key,
    required this.discountController,
    required this.promoStartDate,
    required this.promoEndDate,
    required this.onPercentageSelected,
    required this.onNominalSelected,
    required this.onDiscountChanged,
    required this.onPickStartDate,
    required this.onPickEndDate,
    required this.discountType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Discount",
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
                    "% Percentage",
                  ),
                  selected: discountType == DiscountType.percentage,
                  onSelected: (_) {
                    onPercentageSelected();
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text(
                    "Rp Nominal",
                  ),
                  selected: discountType == DiscountType.nominal,
                  onSelected: (_) {
                    onNominalSelected();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 220,
              child: TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  onDiscountChanged();
                },
                decoration: InputDecoration(
                  labelText: discountType == DiscountType.percentage ? "Discount %" : "Discount Rp",
                  hintText: discountType == DiscountType.percentage ? "Input percentage" : "Input nominal",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 100),

        // RIGHT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Promo Period",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onPickStartDate,
                  icon: const Icon(
                    Icons.calendar_month,
                  ),
                  label: Text(
                    promoStartDate == null
                        ? "Start Date"
                        : DateFormat(
                            'dd MMM yyyy',
                          ).format(
                            promoStartDate!,
                          ),
                  ),
                ),
                const SizedBox(width: 18),
                OutlinedButton.icon(
                  onPressed: onPickEndDate,
                  icon: const Icon(
                    Icons.event,
                  ),
                  label: Text(
                    promoEndDate == null
                        ? "End Date"
                        : DateFormat(
                            'dd MMM yyyy',
                          ).format(
                            promoEndDate!,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
