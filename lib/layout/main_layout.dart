import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakuku_desktop/pages/dashboard/dashboard_page.dart';
import 'package:sakuku_desktop/pages/productpage/produk_page.dart';
import 'package:sakuku_desktop/pages/transaksipage/transaction_page.dart';
import 'package:sakuku_desktop/pages/productreport/ProductReport_page.dart';

import 'package:sakuku_desktop/pages/test_page.dart';
import '../sidebar.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Sidebar(),

          // Konten dinamis
          Expanded(
            child: Navigator(
              key: Get.nestedKey(1),
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case "/":
                  case "/dashboard":
                    return GetPageRoute(
                      routeName: "/dashboard",
                      page: () => Get.find<MainLayoutController>().dashboardPage,
                    );

                  case "/produk":
                    return GetPageRoute(
                      routeName: "/produk",
                      page: () => Get.find<MainLayoutController>().produkPage,
                    );

                  case "/transaksi":
                    return GetPageRoute(
                      routeName: "/transaksi",
                      page: () => Get.find<MainLayoutController>().transaksiPage,
                    );

                  case "/ProductReport":
                    return GetPageRoute(
                      routeName: "/ProductReport",
                      page: () => Get.find<MainLayoutController>().consumerPage,
                    );

                  case "/test":
                    return GetPageRoute(
                      routeName: "/test",
                      page: () => Get.find<MainLayoutController>().testPage,
                    );
                }

                // Fallback biar gak error
                return GetPageRoute(
                  routeName: "/dashboard",
                  page: () => Get.find<MainLayoutController>().dashboardPage,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class MainLayoutController extends GetxController {
  final dashboardPage = const DashboardPage();
  final produkPage = const ProdukPage();
  final transaksiPage = const TransaksiPage();
  final consumerPage = const ProductreportPage();
  final testPage = const TestPage();
}
