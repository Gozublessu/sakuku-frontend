import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sakuku_desktop/api/pipe_api.dart';
import 'package:sakuku_desktop/utils/auto_margin.dart';
import 'package:sakuku_desktop/utils/auto_rupiah.dart';
import 'package:sakuku_desktop/utils/helper_page.dart';
import 'package:sakuku_desktop/utils/snackbar_utils.dart';

// int getAutoHargaJual(String? jenis, int hargaBeli) {
//   return hargaBeli + (hargaBeli * 15 ~/ 100);
// }

class AddProductDialog extends StatefulWidget {
  final NumberFormat formatRupiah;
  final Future<void> Function() fetchProduk;

  const AddProductDialog({
    super.key,
    required this.formatRupiah,
    required this.fetchProduk,
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final namaC = TextEditingController();
  final nettoC = TextEditingController();
  final hargaBeliC = TextEditingController();
  final marginC = TextEditingController();
  final hargaManualC = TextEditingController();
  final stokC = TextEditingController();

  String? selectedJenis;
  int? previewHarga;

  Map<String, String?> errors = {};

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
  ];

  void validateFields() {
    errors.clear();

    if (namaC.text.trim().isEmpty) {
      errors["nama"] = "Nama produk wajib diisi";
    }

    if (selectedJenis == null) {
      errors["jenis"] = "Jenis produk belum dipilih";
    }

    if (parseRupiah(hargaBeliC.text) <= 0) {
      errors["hargaBeli"] = "Harga beli tidak valid";
    }
  }

  int hitungMarginPrice() {
    final beli = parseRupiah(hargaBeliC.text);
    final margin = double.tryParse(marginC.text) ?? 0;
    return (beli + (beli * margin / 100)).round();
  }

  double getHargaFinal() {
    final manual = parseRupiahDouble(hargaManualC.text);

    if (manual > 0) {
      return manual;
    }

    if (previewHarga != null) {
      return previewHarga!.toDouble();
    }

    return hitungMarginPrice().toDouble();
  }

  void updateSuggestion() {
    final beli = parseRupiah(hargaBeliC.text);

    if (beli > 0 && selectedJenis != null) {
      previewHarga = getAutoHargaJual(selectedJenis, beli);
    } else {
      previewHarga = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final marginPrice = hitungMarginPrice();

    return AlertDialog(
      title: const Text(
        "Tambah Produk Manual",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NAMA
              TextField(
                controller: namaC,
                decoration: InputDecoration(
                  labelText: "Nama Produk",
                  errorText: errors["nama"],
                ),
              ),

              const SizedBox(height: 12),

              /// JENIS
              DropdownSearch<String>(
                items: (f, p) => jenisProdukList,
                selectedItem: selectedJenis,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Jenis Produk",
                    errorText: errors["jenis"],
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
                onChanged: (value) {
                  setState(() {
                    selectedJenis = value;
                    updateSuggestion();
                  });
                },
              ),

              const SizedBox(height: 12),

              /// NETTO
              TextField(
                controller: nettoC,
                decoration: const InputDecoration(
                  labelText: "Netto (mis: 250ml)",
                ),
              ),

              const SizedBox(height: 12),

              /// HARGA BELI
              TextField(
                controller: hargaBeliC,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CurrencyInputFormatter()
                ],
                decoration: InputDecoration(
                  labelText: "Harga Beli",
                  errorText: errors["hargaBeli"],
                ),
                onChanged: (v) {
                  setState(() {
                    updateSuggestion();
                  });
                },
              ),

              /// SMART SUGGESTION
              if (previewHarga != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        "Rekomendasi harga jual: ${widget.formatRupiah.format(previewHarga)}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 14),

              /// MARGIN
              TextField(
                controller: marginC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Simulasi Margin (%)",
                ),
                onChanged: (v) {
                  setState(() {});
                },
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.formatRupiah.format(marginPrice),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 4),

              const Text(
                "Harga ini hanya simulasi, tidak otomatis digunakan",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 14),

              /// MANUAL PRICE
              TextField(
                controller: hargaManualC,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CurrencyInputFormatter()
                ],
                decoration: const InputDecoration(
                  labelText: "Harga Jual Manual (Opsional)",
                ),
              ),
              const SizedBox(height: 4),

              const Text(
                "Jika kosong, sistem akan menggunakan harga rekomendasi",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 12),

              /// STOK
              TextField(
                controller: stokC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok Awal",
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          child: const Text("Simpan"),
          onPressed: () async {
            setState(validateFields);

            if (errors.isNotEmpty) return;

            final beli = parseRupiahDouble(hargaBeliC.text);
            final hargaFinal = getHargaFinal();

            if (hargaFinal < beli) {
              SnackbarUtils.showError(
                context,
                "Harga jual tidak boleh lebih kecil dari harga beli",
              );
              return;
            }

            final error = await ProductAPI.addProduct(
              nama: namaC.text.trim(),
              jenis: selectedJenis!,
              netto: nettoC.text.trim(),
              hargaBeli: beli,
              hargaJual: hargaFinal,
              marginPersen: double.tryParse(marginC.text) ?? 0,
              stok: int.tryParse(stokC.text) ?? 0,
            );

            if (error != null) {
              if (error.contains("exists")) {
                setState(() {
                  errors["nama"] = "Produk dengan varian ini sudah ada";
                });
              }

              SnackbarUtils.showError(context, error);
              return;
            }

            await widget.fetchProduk();

            Navigator.pop(context);

            SnackbarUtils.showSucces(
              context,
              "Product added successfully!",
            );
          },
        ),
      ],
    );
  }
}
