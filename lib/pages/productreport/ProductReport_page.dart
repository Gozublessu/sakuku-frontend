import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/models/produk_model.dart';
import 'package:sakuku_desktop/pages/helper/build_search.dart';
import 'package:sakuku_desktop/pages/helper/info_card.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/deep_inisght.dart';
import 'package:sakuku_desktop/pages/productreport/widgets/product_report_table.dart';
import 'package:sakuku_desktop/providers/product_insight_provider.dart';
import 'package:sakuku_desktop/providers/product_provider.dart';

class ProductreportPage extends StatefulWidget {
  const ProductreportPage({super.key});

  @override
  State<ProductreportPage> createState() => _ProductReportPageState();
}

class _ProductReportPageState extends State<ProductreportPage> {
  final ScrollController _controller = ScrollController();
  final TextEditingController searchC = TextEditingController();
  bool _isScrolling = false;
  String? activeProductId;
  late FocusNode _searchFocus;

  void _handleProductAction(ProdukModel product) {
    final provider = context.read<DeepInsightProvider>();

    if (activeProductId == product.kodeProduk) {
      setState(() {
        activeProductId = null;
      });
      provider.clearInsight();
      return;
    }
    setState(() {
      activeProductId = product.kodeProduk;
    });

    provider.loadInsight(productId: product.id);
  }

  @override
  void initState() {
    super.initState();
    _searchFocus = FocusNode();

    _searchFocus.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();

      provider.loadInitial(); // page 1 dari provider
      // total produk
    });

    // Infinite scroll
    _controller.addListener(() {
      final provider = context.read<ProductProvider>();

      if (!provider.hasMore || provider.isLoading) return;

      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        provider.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    searchC.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  final formatRupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardLeft(),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.only(top: 110),
            child: buildCardIsight(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardLeft() {
    final provider = context.watch<ProductProvider>();
    final isSearching = searchC.text.isNotEmpty;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // titlepage
          const Text(
            "Product Report",
            style: TextStyle(
              color: Color(0xFF147BF7),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Overview of your Product Performance",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          Text(
            "Track product performance, monitor stock levels, and optimize profitability.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 432,
                  height: 35,
                  child: GlobalSearchField(
                    controller: searchC,
                    focusNode: _searchFocus,
                    onChanged: (value) {
                      context.read<ProductProvider>().updateSearch(value);
                    },
                    onClear: () {
                      searchC.clear();
                      context.read<ProductProvider>().updateSearch("");
                    },
                    onFilter: () => _openFilter(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 432,
              child: InfoCard(
                value: "${provider.totalProduk}",
                label: provider.summaryLabel,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  setState(() => _isScrolling = true);
                } else if (notification is ScrollEndNotification) {
                  setState(() => _isScrolling = false);
                }
                return false;
              },
              child: ProductTableReport(
                scrollController: _controller,
                produkList: provider.products,
                formatRupiah: formatRupiah,
                fetchProduk: provider.loadNextPage,
                isScrolling: _isScrolling,
                isSearching: isSearching,
                activeProductId: activeProductId,
                onActionPressed: _handleProductAction,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardIsight() {
    return Container(
      height: 800,
      width: 880,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.4,
        ),
      ),
      child: CardDeepInsightReport(),
    );
  }

  void _openFilter(BuildContext context) {
    final provider = context.read<ProductProvider>();

    String? tempCategory = provider.selectedCategory;
    String? movementCategory = provider.movementCategory;
    bool tempLowStock = provider.isLowStockMode;

    final List<String> categories = [
      // "All",
      "FOOD",
      "DRINK",
      "SHAMPOO",
      "BODYWASH",
      "COSMETIC",
      "HANDBODY",
      "FACIALFOAM",
      "SNACKS",
      "ORALCARE",
      "FEMINIME HYGIENE",
      "CONDIMENTS",
      "FORMULA",
    ];

    final List<String> movement = [
      // "All",
      "FAST",
      "NORMAL",
      "NEW",
      "NO DATA",
      "SLOW",
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: 420,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Filter Produk",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownSearch<String>(
                      items: (filter, loadProps) => categories,
                      selectedItem: tempCategory,
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Kategori",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                      ),
                      onChanged: (val) => setState(() => tempCategory = val),
                    ),
                    const SizedBox(height: 10),
                    DropdownSearch<String>(
                      items: (filter, loadProps) => movement,
                      selectedItem: movementCategory,
                      decoratorProps: const DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Movement",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                      ),
                      onChanged: (val) => setState(() => movementCategory = val),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: tempLowStock,
                      title: const Text("Low Stock Only"),
                      onChanged: (val) => setState(() => tempLowStock = val),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // RESET
                              provider.applyFilter(
                                lowStock: false,
                                category: null,
                                movement: null,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text("Reset"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // APPLY
                              provider.applyFilter(
                                lowStock: tempLowStock,
                                category: tempCategory,
                                movement: movementCategory,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text("Apply"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
