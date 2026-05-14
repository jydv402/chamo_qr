import 'package:flutter/material.dart';

/// Build a navigation row with an icon, label, value text, and an on tap callback
///
/// [context] - The context of the widget
/// [icon] - The icon to display
/// [label] - The label to display
/// [valueText] - The value text to display
/// [onTap] - The callback to call when the row is tapped
/// Used in settings_screen.dart
Widget buildNavigationRow(
  BuildContext context, {
  required IconData icon,
  required String label,
  String? valueText,
  required VoidCallback onTap,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(24),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 16),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              if (valueText != null)
                Text(
                  valueText,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
