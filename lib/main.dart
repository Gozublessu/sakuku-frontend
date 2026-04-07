import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sakuku_desktop/layout/main_layout.dart';
import 'package:sakuku_desktop/providers/low_stock_provider.dart';
import 'package:sakuku_desktop/providers/product_insight_provider.dart';
import 'package:sakuku_desktop/providers/summary_provider.dart';
import 'package:sakuku_desktop/providers/tier_list_provider.dart';
import 'package:sakuku_desktop/providers/transactionListProvider.dart';
import 'package:sakuku_desktop/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:sakuku_desktop/sidebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SummaryProvider()),
        ChangeNotifierProvider(create: (_) => TransactionListProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => TierListProvider()),
        ChangeNotifierProvider(create: (_) => ProductInsightProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => DeepInsightProvider()),
      ],
      child: const SakukuApp(),
    ),
  );
}

class SakukuApp extends StatelessWidget {
  const SakukuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      initialBinding: BindingsBuilder(() {
        Get.put(MainLayoutController());
        Get.put(SidebarController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const MainLayout()),
      ],
    );
  }
}
