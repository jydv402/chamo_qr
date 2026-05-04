import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:chamo_qr_app/elements/build_base_bottom_sheet.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String header;
  final String message;
  final Function() onConfirm;
  const ConfirmationBottomSheet({
    super.key,
    required this.header,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BaseBottomSheet(
      children: [
        Text(
          header,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(message, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  onConfirm();
                  Get.back();
                },
                child: Text(
                  "Confirm",
                  style: TextStyle(color: isDark ? Colors.black : Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
