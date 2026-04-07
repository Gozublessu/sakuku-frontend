// // import 'package:flutter/material.dart';

// // class WalletPage extends StatelessWidget {
// //   const WalletPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Scaffold(
// //       body: Center(
// //         child: Text("walletPage", style: TextStyle(fontSize: 30, color: Colors.blueAccent)),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'transaction_card.dart';

// class TryTransaksiPage extends StatefulWidget {
//   const TryTransaksiPage({super.key});

//   @override
//   State<TryTransaksiPage> createState() => _TryTransaksiPageState();
// }

// class _TryTransaksiPageState extends State<TryTransaksiPage> {
//   // Dummy grouped data
//   final Map<String, List<Map<String, dynamic>>> dummyGrouped = {
//     "19 Feb 2026": [
//       {
//         "id": 1813,
//         "penjualan": 6900,
//         "modal": 4100
//       },
//       {
//         "id": 1812,
//         "penjualan": 228480,
//         "modal": 163200
//       },
//     ],
//     "18 Feb 2026": [
//       {
//         "id": 1811,
//         "penjualan": 3600,
//         "modal": 2400
//       },
//       {
//         "id": 1810,
//         "penjualan": 36200,
//         "modal": 29000
//       },
//     ]
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           _buildSummary(),

//           const SizedBox(height: 20),

//           // Render group per tanggal
//           ...dummyGrouped.entries.map((group) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   group.key,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // Render card per transaksi
//                 ...group.value.map((trx) {
//                   return TransactionCard(
//                     id: trx["id"],
//                     penjualan: trx["penjualan"],
//                     modal: trx["modal"],
//                   );
//                 }),

//                 const SizedBox(height: 25),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummary() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Ringkasan Keuangan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Text("Total Penjualan: Rp 3.170.260"),
//           Text("Total Modal     : Rp 2.423.700"),
//           Text("Total Profit    : Rp 746.560",
//               style: TextStyle(
//                 color: Colors.green,
//                 fontWeight: FontWeight.bold,
//               )),
//         ],
//       ),
//     );
//   }
// }
