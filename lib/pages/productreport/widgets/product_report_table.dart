import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sakuku_desktop/models/produk_model.dart';

import 'package:sakuku_desktop/utils/hover_wrapper.dart';

class ProductTableReport extends StatelessWidget {
  final ScrollController scrollController;
  final List<ProdukModel> produkList;
  final NumberFormat formatRupiah;
  final VoidCallback fetchProduk;
  final bool isScrolling;
  final bool isSearching;
  final String? activeProductId;
  final Function(ProdukModel) onActionPressed;

  const ProductTableReport({
    super.key,
    required this.produkList,
    required this.formatRupiah,
    required this.fetchProduk,
    required this.scrollController,
    required this.isScrolling,
    required this.isSearching,
    required this.activeProductId,
    required this.onActionPressed,
  });

  static const _headingTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 13,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name",
                        style: _headingTextStyle,
                      ))),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Movement",
                    style: _headingTextStyle,
                  ),
                ),
              ),
              // ),

              Expanded(flex: 1, child: SizedBox()), // aksi (kosong header)
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Data Rows

        Expanded(
          child: produkList.isEmpty
              ? Center(
                  child: Text(
                    isSearching ? "Product not found" : "no products yet",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 32),
                  ),
                )
              : ListView.separated(
                  controller: scrollController,
                  itemCount: produkList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = produkList[index];
                    final isActive = activeProductId == item.kodeProduk;

                    return HoverWrapper(
                      scale: 1.02,
                      enabled: !isScrolling,
                      hoverDelay: const Duration(milliseconds: 300),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.blue.shade100 : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.black12,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.namaProduk,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      item.kodeProduk,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.movement,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    splashRadius: 18,
                                    tooltip: "action",
                                    icon: const Icon(
                                      Icons.arrow_circle_right_outlined,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => onActionPressed(item),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
