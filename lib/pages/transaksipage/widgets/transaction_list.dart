import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/transactions_header_model.dart';
import '../../../utils/helper_page.dart';

class TransactionList extends StatelessWidget {
  final ScrollController controller;
  final List<TransactionHeaderModel> transactions;
  final List<bool> expanded;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final void Function(int index) onToggle;

  const TransactionList({
    super.key,
    required this.controller,
    required this.transactions,
    required this.expanded,
    required this.hasMore,
    required this.onLoadMore,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: transactions.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= transactions.length) {
          return hasMore
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox();
        }

        if (index >= expanded.length) {
          return const SizedBox();
        }

        final tr = transactions[index];
        final isOpen = expanded[index];

        return _TransactionCard(
          tr: tr,
          isOpen: isOpen,
          onTap: () => onToggle(index),
        );
      },
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionHeaderModel tr;
  final bool isOpen;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.tr,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14, right: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TransactionHeader(tr: tr, isOpen: isOpen),
                if (isOpen) _TransactionDetails(tr: tr),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionHeader extends StatelessWidget {
  final TransactionHeaderModel tr;
  final bool isOpen;

  const _TransactionHeader({
    required this.tr,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transaksi ID.${tr.id}",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatDate2(tr.date),
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Penjualan: ${rupiah(tr.totalPenjualan)}", style: _detailStyle()),
                Text("Modal: ${rupiah(tr.totalModal)}", style: _detailStyle()),
                Text(
                  "Profit: ${rupiah(tr.totalProfit)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 28,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  TextStyle _detailStyle() {
    return TextStyle(
      fontSize: 13,
      color: Colors.grey.shade800,
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  final TransactionHeaderModel tr;

  const _TransactionDetails({
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        const Divider(),
        const SizedBox(height: 6),
        const Text(
          "Detail Items:",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 10),
        ...tr.items.map(
          (it) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${it.namaProduk} x ${it.qty}pcs",
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  rupiah(it.subtotalJual),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
