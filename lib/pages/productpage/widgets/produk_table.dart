import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/models/produk_model.dart';
import 'package:sakuku_desktop/providers/product_provider.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';
import 'package:sakuku_desktop/utils/hover_wrapper.dart';

class ProductTable extends StatelessWidget {
  final ScrollController scrollController;
  final List<ProdukModel> produkList;
  final NumberFormat formatRupiah;
  final VoidCallback fetchProduk;
  final bool isScrolling;
  final bool isSearching;
  final String? activeProductId;
  final Function(ProdukModel) onActionPressed;

  const ProductTable({
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

  static const _rowTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();

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
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Category",
                    style: _headingTextStyle,
                  ),
                ),
              ),
              Expanded(flex: 1, child: Align(alignment: Alignment.center, child: Text("Netto", style: _headingTextStyle))),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    provider.applyFilter(lowStock: !provider.isLowStockMode);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Stock", style: _headingTextStyle),
                      SizedBox(width: 4),
                      Icon(
                        provider.isLowStockMode ? Icons.clear : Icons.filter_alt,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              // ),

              Expanded(flex: 1, child: Align(alignment: Alignment.center, child: Text("Sold", style: _headingTextStyle))),
              Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text("Purchase", style: _headingTextStyle))),
              Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text("Selling", style: _headingTextStyle))),
              Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text("Margin", style: _headingTextStyle))),

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

                    Color stokColor;
                    if (item.jumlahProduk <= 0) {
                      stokColor = Colors.red;
                    } else if (item.jumlahProduk <= 5) {
                      stokColor = Colors.orange;
                    } else {
                      stokColor = Colors.green;
                    }

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
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.jenisProduk,
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
                                      alignment: Alignment.center,
                                      child: Text(
                                        formatNetto(item.netto),
                                        style: _rowTextStyle,
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        (item.jumlahProduk).toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: stokColor,
                                        ),
                                      ))),
                              Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text((item.totalSold).toString(), style: _rowTextStyle))),
                              Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text(formatRupiah.format(item.hargaBeli), style: _rowTextStyle))),
                              Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text(formatRupiah.format(item.hargaJual), style: _rowTextStyle))),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatRupiah.format(item.marginRupiah),
                                        style: _rowTextStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "${item.marginPersen.toStringAsFixed(1)}%",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                      Icons.more_vert,
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
