import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/insight_produk_model.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

class PromoBadge extends StatelessWidget {
  final ProductInsightResponse data;

  const PromoBadge({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final promo = data.promoProduct;

    if (promo.promoStatus == "ACTIVE") {
      return _activePromo();
    }

    if (promo.promoStatus == "SCHEDULED") {
      return _scheduledPromo();
    }

    return const SizedBox.shrink();
  }

  Widget _activePromo() {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
        bottom: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange.shade100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.orange.shade700,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            data.promoProduct.promoType ?? "-",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.orange.shade900,
            ),
          ),
          const SizedBox(width: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rupiah(
                  data.product.hargaJual,
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.redAccent,
                  decorationThickness: 2,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                rupiah(
                  data.promoProduct.promoPrice?.toInt() ?? 0,
                ),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Text(
            formatDate2(
              data.promoProduct.endDate,
            ),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduledPromo() {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
        bottom: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.shade100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            color: Colors.blue.shade700,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            "${data.promoProduct.promoType} start soon",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.blue.shade900,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatDate2(
              data.promoProduct.startDate,
            ),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
