import 'package:flutter/material.dart';

import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_information_section.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_result_section.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_summary_card.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_basic_info.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_header.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_scope_section.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/promo_workspace/promo_discount_section.dart';
import 'package:sakuku_desktop/models/insight_produk_model.dart';

class PromoWorkSpacePage extends StatefulWidget {
  final VoidCallback onBack;
  final ProductInsightResponse insight;

  const PromoWorkSpacePage({
    required this.onBack,
    required this.insight,
    super.key,
  });
  @override
  State<PromoWorkSpacePage> createState() => _PromoWorkSpace();
}

class _PromoWorkSpace extends State<PromoWorkSpacePage> {
  final ScrollController _promoScrollController = ScrollController();
  String rightPanelMode = "insight";

  final discountController = TextEditingController();
  final promoLabelController = TextEditingController();
  final promoNoteController = TextEditingController();
  DateTime? promoStartDate;
  DateTime? promoEndDate;
  bool applyAllStock = true;

  final promoQtyController = TextEditingController();
  DiscountType discountType = DiscountType.percentage;

  @override
  Widget build(BuildContext context) {
    final product = widget.insight;

    final discountValue = parseRupiahDouble(
      discountController.text,
    );

    final discountedPrice = discountType == DiscountType.percentage
        ? calculateDiscountedPrice(
            product.product.hargaJual.toDouble(),
            discountValue,
          )
        : product.product.hargaJual - discountValue;

    final newMargin = discountedPrice - product.product.hargaBeli;
    final profitStatus = newMargin <= 0
        ? "LOSS"
        : newMargin < 1000
            ? "LOW"
            : "SAFE";
    final selectedQty = applyAllStock
        ? product.product.stok
        : int.tryParse(
              promoQtyController.text,
            ) ??
            0;

    String promoSummary = "";

    if (profitStatus == "LOSS") {
      promoSummary = "This promo may cause financial loss.";
    } else if (profitStatus == "LOW") {
      promoSummary = "Profit margin is getting low.";
    } else {
      promoSummary = "Promo is still within safe margin.";
    }

    return Container(
      width: 880,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade300,
          width: 1.4,
        ),
      ),
      child: SingleChildScrollView(
        controller: _promoScrollController,
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromoHeader(
              title: "Create Promo",
              onBack: widget.onBack,
              productName: product.product.nama,
              netto: product.product.netto,
            ),
            const SizedBox(height: 24),
            PromoBasicInfo(
              buyPrice: rupiah(product.product.hargaBeli),
              sellPrice: rupiah(product.product.hargaJual),
              margin: "${product.product.marginPersen.toStringAsFixed(1)}%",
              stock: "${product.product.stok} Pcs",
              statCard: const SizedBox(),
            ),
            const SizedBox(height: 10),
            PromoDiscountSection(
              discountType: discountType,
              discountController: discountController,
              promoStartDate: promoStartDate,
              promoEndDate: promoEndDate,
              onPercentageSelected: () {
                setState(() {
                  discountType = DiscountType.percentage;
                });
              },
              onNominalSelected: () {
                setState(() {
                  discountType = DiscountType.nominal;
                });
              },
              onDiscountChanged: () {
                if (discountType == DiscountType.nominal) {
                  final formatted = formatInputRupiah(
                    discountController.text,
                  );

                  discountController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                }

                setState(() {});
              },
              onPickStartDate: () {
                pickPromoDate(
                  isStart: true,
                );
              },
              onPickEndDate: () {
                pickPromoDate(
                  isStart: false,
                );
              },
            ),
            const SizedBox(height: 24),
            PromoScopeSection(
              applyAllStock: applyAllStock,
              promoQtyController: promoQtyController,
              onAllStock: () {
                setState(() {
                  applyAllStock = true;
                });
              },
              onCustomQty: () {
                setState(() {
                  applyAllStock = false;
                });
              },
              onQtyChanged: () {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            PromoResultSection(
              newPrice: rupiah(discountedPrice.toInt()),
              newMargin: rupiah(newMargin.toInt()),
              selectedQty: selectedQty,
              profitStatus: profitStatus,
              statusColor: getProfitStatusColor(
                profitStatus,
              ),
            ),
            const SizedBox(height: 16),
            PromoSummaryCard(
              summary: promoSummary,
            ),
            const SizedBox(height: 10),
            Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
            PromoInformationSection(
              promoLabelController: promoLabelController,
              promoNoteController: promoNoteController,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> pickPromoDate({
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        promoStartDate = picked;
      } else {
        promoEndDate = picked;
      }
    });
  }

  Color getProfitStatusColor(String status) {
    switch (status) {
      case "SAFE":
        return Colors.green;

      case "LOW":
        return Colors.orange;

      case "LOSS":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}
