import 'package:flutter/material.dart';
import 'package:sakuku_desktop/models/produk_model.dart';
import 'package:sakuku_desktop/pages/productpage/widgets/edit_product_dialog.dart';

class ProductActionDialog extends StatelessWidget {
  final ProdukModel product;
  final VoidCallback onUpdate;

  const ProductActionDialog({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Pilih Aksi"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Edit Informasi Produk"),
              subtitle: const Text("Nama, jenis, netto, harga jual"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => EditProductDialog(
                    product: product,
                    onUpdate: onUpdate,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: Colors.orange),
              title: const Text("Restock Produk"),
              subtitle: const Text("Tambah stok & dicatat ke histori"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => RestockProductDialog(
                    product: product,
                    onUpdate: onUpdate,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.search,
                color: Colors.deepPurpleAccent,
              ),
              title: const Text("Detail Produk"),
              subtitle: const Text("lo siento,wilson..."),
              onTap: () {},
            )
          ],
        ));
  }
}
