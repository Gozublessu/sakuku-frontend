import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/providers/low_stock_provider.dart';
import 'package:get/get.dart';
import 'package:sakuku_desktop/providers/product_provider.dart';
import 'package:sakuku_desktop/sidebar.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

// class StockLowCard extends StatelessWidget {
//   const StockLowCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<DashboardProvider>();
//     final lowStock = provider.lowStock;
//     final updateStock = provider.updates;
//     final items = lowStock?.data.take(5).toList() ?? [];

//     return Container(
//       height: 515,
//       width: 350,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Highlight Stock",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 4),

//           Text(
//             "Stock baru di tambahkan",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 15),
//           if (provider.isUpdateLoad)
//             const Text(
//               "loading...",
//               style: TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           if (updateStock.isEmpty)
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 24),
//                 child: Text(
//                   "belum ada data",
//                 ),
//               ),
//             ),
//           ...List.generate(updateStock.length, (index) {
//             final item = updateStock[index];

//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item.name,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12,
//                       ),
//                     ),
//                     Text(
//                       formatDate2(item.createdAt),
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 5),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: item.type ? Colors.green : Colors.blue,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         item.type ? "New" : "Restock",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       ("${item.qty} pcs"),
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           }),

//           const SizedBox(height: 60),
//           Text(
//             "Status Stock",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 15),

//           Expanded(
//             child: Builder(
//               builder: (_) {
//                 if (provider.isLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   );
//                 }

//                 if (items.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "Stock aman...",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   );
//                 }

//                 return ListView.separated(
//                   itemCount: items.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 6),
//                   itemBuilder: (context, index) {
//                     final item = items[index];

//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           ("- ${item.name}"),
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           ("${item.stock} pcs"),
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: item.stock == 0
//                                 ? Colors.redAccent
//                                 : item.stock <= 2
//                                     ? Colors.orangeAccent
//                                     : Colors.yellow,
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 15),
//           Text(
//             "Total stok menipis: ${provider.lowStock?.count ?? 0} produk",
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 30),
//           Align(
//             alignment: Alignment.centerRight,
//             child: TextButton(
//               onPressed: items.isEmpty
//                   ? null
//                   : () {
//                       final provider = Get.context!.read<ProductProvider>();
//                       provider.applyFilter(lowStock: !provider.isLowStockMode);
//                       Get.find<SidebarController>().activeIndex.value = 2; // 2 = Produk

//                       Get.toNamed('/produk', id: 1);
//                     },
//               style: TextButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   )),
//               child: const Text(
//                 "Selengkapnya",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),

//           // Contoh tampilkan 1 item dulu
//         ],
//       ),
//     );
//   }
// }
class StockLowCard extends StatelessWidget {
  const StockLowCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final lowStock = provider.lowStock;
    final updateStock = provider.updates;

    final lowItems = lowStock?.data.take(5).toList() ?? [];
    final newCount = updateStock.where((e) => e.type).length;
    final restockCount = updateStock.where((e) => !e.type).length;

    return Container(
      height: 515,
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Inventory Highlight",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Recent stock activity",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          /// MINI STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniStat("New", newCount, Colors.green),
              _miniStat("Restock", restockCount, Colors.blue),
              _miniStat("Low", provider.lowStock?.count ?? 0, Colors.orange),
            ],
          ),

          const SizedBox(height: 10),

          /// RECENT ACTIVITY
          const Text(
            "Recent Activity",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          if (provider.isUpdateLoad) const Center(child: CircularProgressIndicator(strokeWidth: 2)),

          if (!provider.isUpdateLoad)
            Column(
              children: updateStock.take(3).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// PRODUCT INFO
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            formatDate2(item.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      /// QTY + TYPE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "+${item.qty}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.type ? Colors.green : Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.type ? "NEW" : "RESTOCK",
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          const Divider(height: 30),

          /// LOW STOCK TITLE
          const Text(
            "Low Stock Alert",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          /// LOW STOCK LIST
          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }

                if (lowItems.isEmpty) {
                  return const Center(
                    child: Text(
                      "Stock aman...",
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: lowItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 1),
                  itemBuilder: (context, index) {
                    final item = lowItems[index];

                    Color color;

                    if (item.stock == 0) {
                      color = Colors.redAccent;
                    } else if (item.stock <= 2) {
                      color = Colors.orangeAccent;
                    } else {
                      color = Colors.amber;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${item.stock}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          /// TOTAL LOW STOCK
          Text(
            "Total low stock: ${provider.lowStock?.count ?? 0} produk",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          // const SizedBox(height: 16),

          /// BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: lowItems.isEmpty
                  ? null
                  : () {
                      final provider = Get.context!.read<ProductProvider>();

                      provider.applyFilter(lowStock: !provider.isLowStockMode);

                      Get.find<SidebarController>().activeIndex.value = 2;

                      Get.toNamed('/produk', id: 1);
                    },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Selengkapnya",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// MINI STAT WIDGET
  Widget _miniStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
