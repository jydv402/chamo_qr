import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the bottom navigation controller
    final BottomNavController controller = Get.find();
    // Check if the current theme is dark
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
            ),
          if (isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.05),
              spreadRadius: 1,
            ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavItem(
              context: context,
              icon: Icons.qr_code_scanner_rounded,
              index: 0,
              isSelected: controller.currentIndex.value == 0,
              onTap: () => controller.changeIndex(0),
            ),
            const SizedBox(width: 4),
            _buildNavItem(
              context: context,
              icon: Icons.add_rounded,
              index: 1,
              isSelected: controller.currentIndex.value == 1,
              onTap: () => controller.changeIndex(1),
              isCenter: true,
            ),
            const SizedBox(width: 4),
            _buildNavItem(
              context: context,
              icon: Icons.history_rounded,
              index: 2,
              isSelected: controller.currentIndex.value == 2,
              onTap: () => controller.changeIndex(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
    bool isCenter = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    // Determine colors based on selection and dark mode
    Color bgColor;
    Color iconColor;

    if (isSelected) {
      if (isCenter) {
        bgColor = primaryColor;
        iconColor = isDark ? Colors.black : Colors.white;
        // Adjust if primaryColor is very dark config in dark mode
        if (isDark) {
          bgColor = Colors.white;
          iconColor = Colors.black;
        } else {
          bgColor = Colors.black;
          iconColor = Colors.white;
        }
      } else {
        bgColor = isDark ? Colors.white : Colors.black;
        iconColor = isDark ? Colors.black : Colors.white;
      }
    } else {
      bgColor = Colors.transparent;
      iconColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Center(child: Icon(icon, color: iconColor, size: 24)),
      ),
    );
  }
}
