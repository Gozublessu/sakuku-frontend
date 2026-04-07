import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_produk_dialog.dart';
import 'package:sakuku_desktop/utils/snackbar_utils.dart';

class TambahProdukDialog extends StatelessWidget {
  final Future<void> Function() fetchProduk;
  final Future<bool> Function() importProdukExcel;
  final NumberFormat formatRupiah;
  final bool mounted;
  final BuildContext parentContext;

  const TambahProdukDialog({
    super.key,
    required this.fetchProduk,
    required this.importProdukExcel,
    required this.formatRupiah,
    required this.mounted,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext dialogContext) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 47, 70, 116),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      title: const Text(
        "Tambah Produk",
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogButton("Input Manual", () {
            Navigator.pop(dialogContext);

            showDialog(
              context: parentContext,
              builder: (_) => AddProductDialog(
                formatRupiah: formatRupiah,
                fetchProduk: fetchProduk,
              ),
            );
          }),
          const SizedBox(height: 12),
          _buildDialogButton("Add & Update Excel", () async {
            bool success = await importProdukExcel();
            if (!mounted) return;

            if (success) {
              await fetchProduk();
              if (!mounted) return;

              Navigator.pop(dialogContext);

              SnackbarUtils.showSucces(parentContext, "Data berhasil ditambahkan!");
            }
          }),
        ],
      ),
    );
  }

  Widget _buildDialogButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        minimumSize: const Size(double.infinity, 45),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
