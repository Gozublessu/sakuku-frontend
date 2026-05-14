import 'package:flutter/material.dart';

class PromoInformationSection extends StatelessWidget {
  final TextEditingController promoLabelController;

  final TextEditingController promoNoteController;

  const PromoInformationSection({
    super.key,
    required this.promoLabelController,
    required this.promoNoteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Promo Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: 320,
          child: TextField(
            controller: promoLabelController,
            decoration: InputDecoration(
              labelText: "Promo Label",
              hintText: "Ex: Mei Berkah",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 500,
          child: TextField(
            controller: promoNoteController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "Notes",
              hintText: "Ex: Push weekend sales",
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
