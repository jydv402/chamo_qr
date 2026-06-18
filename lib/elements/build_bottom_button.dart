import 'package:flutter/material.dart';
import 'package:chamo_qr_app/utils/haptic_helper.dart';

/// Build a bottom button with icon and label
///
/// [icon] - The icon to display on the button
/// [label] - The label to display on the button
/// [onTap] - The callback to be called when the button is pressed
/// Used in qr_display.dart, scan_result_bottom_sheet.dart
Widget buildBottomButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return SizedBox(
    height: 56,
    child: ElevatedButton(
      onPressed: () {
        HapticHelper.light();
        onTap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.grey[700] : Colors.grey[100],
        foregroundColor: isDark ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}
