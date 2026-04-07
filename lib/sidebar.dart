import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sakuku_desktop/widgets/premium_tooltip.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int? hoveredIndex; //
  int activeIndex = 0;
  final sidebarC = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: 152,
        color: const Color(0xFF147BF7),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // logo
            SizedBox(
              width: 75,
              height: 75,
              child: Image.asset(
                "assets/logo6.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 35),
            _item("assets/icons/dashboard.svg", "/dashboard", 0, "Dashboard"),
            const SizedBox(height: 25),
            _item("assets/icons/transactions.svg", "/transaksi", 1, "Transaction"),
            const SizedBox(height: 25),
            _item("assets/icons/package.svg", "/produk", 2, "Products"),
            const SizedBox(height: 25),
            _item("assets/icons/report.svg", "/ProductReport", 3, "Product Report"),
            const SizedBox(height: 25),
            _item("assets/icons/flowchart.svg", "/test", 4, "Financial Analyts"),
            const Spacer()
          ],
        ),
      ),
    );
  }

  Widget _item(String assetsPath, String routeName, int index, String tooltipName) {
    final bool isHovered = hoveredIndex == index;
    final bool isActive = sidebarC.activeIndex.value == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      hitTestBehavior: HitTestBehavior.opaque,
      onEnter: (_) => setState(() => hoveredIndex = index),
      onExit: (_) => setState(() => hoveredIndex = null),
      child: GestureDetector(
        onTap: () {
          sidebarC.activeIndex.value = index;
          Get.toNamed(routeName, id: 1);
        },
        child: PremiumTooltip(
          message: tooltipName.capitalizeFirst!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 3,
                  height: isActive ? 40 : 0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                AnimatedScale(
                  scale: isHovered ? 1.0 : 0.92,
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isHovered ? const Color.fromRGBO(255, 255, 255, 0.15) : Colors.transparent,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Center(
                      child: SvgPicture.asset(
                        assetsPath,
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                          isActive
                              ? Colors.white // aktif: terang
                              : Colors.white.withOpacity(isHovered ? 0.9 : 0.55),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SidebarController extends GetxController {
  var activeIndex = 0.obs;
}
