class UpdateMetaModel {
  final String namaProduk;
  final String netto;
  final String jenisProduk;

  UpdateMetaModel({
    required this.namaProduk,
    required this.netto,
    required this.jenisProduk,
  });

  Map<String, dynamic> toJson() {
    return {
      "Nama_produk": namaProduk,
      "NETTO": netto,
      "Jenis_produk": jenisProduk,
    };
  }
}
