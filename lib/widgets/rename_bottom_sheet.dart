import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:chamo_qr_app/elements/build_base_bottom_sheet.dart';
import 'package:chamo_qr_app/utils/haptic_helper.dart';

class RenameBottomSheet extends StatelessWidget {
  final TextEditingController nameController;
  final Function onConfirm;
  final String? title;
  const RenameBottomSheet({
    super.key,
    required this.nameController,
    required this.onConfirm,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    nameController.text = title ?? '';
    return BaseBottomSheet(
      children: [
        Text(
          'Edit Name',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: nameController,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Enter a custom name",
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(height: 56),
        Row(
          spacing: 12,
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
                onPressed: () {
                  HapticHelper.trigger();
                  Get.back();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
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
                  HapticHelper.trigger();
                  onConfirm();
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
