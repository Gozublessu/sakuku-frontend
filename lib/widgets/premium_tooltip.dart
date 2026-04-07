import 'package:flutter/material.dart';

class PremiumTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final Color tooltipColor;
  final Color TextColor;

  const PremiumTooltip({
    super.key,
    required this.child,
    required this.message,
    this.tooltipColor = const Color(0xFF2F89FF),
    this.TextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      decoration: BoxDecoration(
        color: tooltipColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 192, 192, 192).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: TextStyle(
        color: TextColor,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      verticalOffset: 18,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 250),
      showDuration: const Duration(milliseconds: 3000),
      child: child,
    );
  }
}
