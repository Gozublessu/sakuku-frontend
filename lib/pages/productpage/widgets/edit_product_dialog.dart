import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sakuku_desktop/models/produk_model.dart';
import 'package:sakuku_desktop/models/restock_model.dart';
import 'package:sakuku_desktop/models/update_meta_model.dart';
import 'package:sakuku_desktop/providers/product_provider.dart';
import 'package:sakuku_desktop/utils/auto_rupiah.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';

class EditProductDialog extends StatefulWidget {
  final ProdukModel product; // produk yang mau diedit
  final VoidCallback onUpdate; // callback untuk refresh list di parent

  const EditProductDialog({
    required this.product,
    required this.onUpdate,
    super.key,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController namaController;
  late TextEditingController nettoController;
  late TextEditingController jenisController;

  String? selectedJenis;
  // Note : strike dropdown
  final List<String> jenisProdukList = [
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

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.product.namaProduk);
    selectedJenis = widget.product.jenisProduk;
    nettoController = TextEditingController(text: widget.product.netto);
  }

  @override
  void dispose() {
    namaController.dispose();
    nettoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Produk"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            TextField(
              controller: nettoController,
              decoration: const InputDecoration(labelText: "NETTO"),
            ),
            DropdownSearch<String>(
              items: (filter, loadProps) => jenisProdukList,
              selectedItem: selectedJenis,
              onChanged: (value) {
                setState(() {
                  selectedJenis = value;
                });
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "Jenis Produk",
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            final request = UpdateMetaModel(
              namaProduk: namaController.text,
              netto: nettoController.text,
              jenisProduk: selectedJenis ?? '',
            );

            final success = await context.read<ProductProvider>().updateMeta(
                  kodeProduk: widget.product.kodeProduk,
                  request: request,
                );

            if (success) {
              widget.onUpdate();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Produk berhasil di Edit"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gagal update produk")),
              );
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}

class RestockProductDialog extends StatefulWidget {
  final ProdukModel product;
  final VoidCallback onUpdate;

  const RestockProductDialog({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  State<RestockProductDialog> createState() => _RestockProductDialogState();
}

class _RestockProductDialogState extends State<RestockProductDialog> {
  late TextEditingController qtyController;
  late TextEditingController hargaBeliController;
  late TextEditingController hargaJualController;

  @override
  void initState() {
    super.initState();

    hargaBeliController = TextEditingController(text: rupiah(widget.product.hargaBeli, noMinus: true));

    hargaJualController = TextEditingController(text: rupiah(widget.product.hargaJual));
    qtyController = TextEditingController();
  }

  @override
  void dispose() {
    qtyController.dispose();
    hargaBeliController.dispose();
    hargaJualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Restock Produk"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.product.namaProduk,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 8),
          Text("Stok saat ini: ${widget.product.jumlahProduk}"),
          const SizedBox(height: 8),
          TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Jumlah masuk",
              helperText: "Akan dicatat ke histori",
            ),
          ),
          TextField(
            controller: hargaBeliController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyInputFormatter(),
            ],
            decoration: const InputDecoration(
              labelText: "Harga beli",
            ),
          ),
          TextField(
            controller: hargaJualController,
            inputFormatters: [
              CurrencyInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Harga jual",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () async {
            final beli = parseRupiahDouble(hargaBeliController.text);
            final jual = parseRupiahDouble(hargaJualController.text);

            if (beli <= 0 || jual <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Harga tidak valid")),
              );
              return;
            }

            if (jual < beli) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Harga jual tidak boleh lebih kecil dari harga beli")),
              );
              return;
            }
            final request = RestockRequest(
              jumlahProduk: int.parse(qtyController.text),
              hargaJual: parseRupiahDouble(hargaJualController.text),
              hargaBeli: parseRupiahDouble(hargaBeliController.text),
            );

            final success = await context.read<ProductProvider>().restock(
                  kodeProduk: widget.product.kodeProduk,
                  request: request,
                );

            if (success) {
              widget.onUpdate();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Produk berhasil di restock"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gagal update produk")),
              );
            }
          },
          child: const Text("Restock"),
        ),
      ],
    );
  }
}
