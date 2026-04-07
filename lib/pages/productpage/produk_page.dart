import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sakuku_desktop/api/pipe_api.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sakuku_desktop/models/produk_model.dart';
import 'package:sakuku_desktop/pages/helper/info_card.dart';
import 'package:sakuku_desktop/pages/productpage/widgets/product_action_dialog.dart';
import 'package:sakuku_desktop/pages/productpage/widgets/tambah_produk_dialog.dart';

import 'package:sakuku_desktop/pages/productpage/widgets/produk_table.dart';

import 'package:sakuku_desktop/utils/hover_wrapper.dart';

import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  final ScrollController _controller = ScrollController();
  final TextEditingController searchC = TextEditingController();
  bool _isScrolling = false;
  String? activeProductId;
  late FocusNode _searchFocus;

  void _handleProductAction(ProdukModel product) {
    final provider = context.read<ProductProvider>();
    setState(() {
      activeProductId = product.kodeProduk;
    });

    showDialog(
      context: context,
      builder: (_) => ProductActionDialog(
        product: product,
        onUpdate: provider.loadNextPage,
      ),
    ).then((_) {
      setState(() {
        activeProductId = null;
      });
    });
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

    // Search realtime
    searchC.addListener(() {
      final provider = context.read<ProductProvider>();
      provider.updateSearch(searchC.text.toLowerCase());
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

  Future<bool> importProdukExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'xlsx'
      ],
    );

    if (result == null) return false;

    final path = result.files.single.path!;
    return await apiImportExcel(path);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final isSearching = searchC.text.isNotEmpty;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Product Management",
                  style: TextStyle(
                    color: Color(0xFF2F89FF),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // SizedBox(height: 1),
                Text(
                  "Manage your products inventory",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Track product performance, monitor stock levels, and optimize profitability.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 320,
                  height: 35,
                  child: buildSearchField(),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  // width: 100,
                  height: 35,
                  child: buildTambahButton(),
                ),
                // const SizedBox(width: 30),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 250,
                      height: 35,
                      child: InfoCard(
                        label: provider.summaryLabel,
                        value: "${provider.totalProduk}",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
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
              child: ProductTable(
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

  Widget buildSearchField() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchFocus.hasFocus ? const Color(0xFF2F89FF) : Colors.grey.shade300,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchC,
              focusNode: _searchFocus,
              onChanged: (value) {
                context.read<ProductProvider>().updateSearch(value);
                setState(() {}); // biar icon close muncul realtime
              },
              decoration: InputDecoration(
                hintText: "Search product...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          if (searchC.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                searchC.clear();
                context.read<ProductProvider>().updateSearch("");
                setState(() {});
              },
              child: Icon(Icons.close, size: 18, color: Colors.grey.shade500),
            ),
          const SizedBox(width: 8),
          HoverWrapper(
            scale: 1.3,
            child: GestureDetector(
              onTap: () => _openFilter(context),
              child: Icon(Icons.tune, size: 20, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTambahButton() {
    return HoverWrapper(
      scale: 1.03,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          showDialog(
            context: context,
            builder: (dialogContext) => TambahProdukDialog(
              fetchProduk: () => context.read<ProductProvider>().loadInitial(),
              importProdukExcel: importProdukExcel,
              formatRupiah: formatRupiah,
              mounted: mounted,
              parentContext: context,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF2F89FF),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: const Color(0xFF2F89FF).withOpacity(0.25),
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                "Add Product",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
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
    ];

    // final List<String> movement = [
    //   // "All",
    //   "FAST",
    //   "NORMAL",
    //   "FLASH SPIKE",
    //   "BULK PURCHASE PATTERN",
    //   "BURST DEMAND",
    //   "SPIKE PRODUCT",
    //   "NEW",
    // ];

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
