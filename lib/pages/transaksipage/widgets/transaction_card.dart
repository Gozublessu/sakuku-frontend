import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  final int id;
  final int penjualan;
  final int modal;

  const TransactionCard({
    super.key,
    required this.id,
    required this.penjualan,
    required this.modal,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final profit = widget.penjualan - widget.modal;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          ListTile(
            title: Text("Transaksi #${widget.id}"),
            subtitle: const Text("19 Feb 2026 — 07:01"),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => expanded = !expanded),
            ),
          ),

          // Expanded content
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Penjualan: Rp ${widget.penjualan}"),
                  Text("Modal: Rp ${widget.modal}"),
                  Text(
                    "Profit: Rp $profit",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
