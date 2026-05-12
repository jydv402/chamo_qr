import 'package:flutter/material.dart';

/// Build a section header with title
///
/// [title] - The title to display on the header
/// Used in qr_display.dart, settings_screen.dart
Widget buildSectionHeader(BuildContext context, String title, String? warning) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final TextStyle textStyle = TextStyle(
    color: isDark ? Colors.grey[500] : Colors.grey[600],
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );
  return Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 12, top: 32),
    child: Text.rich(
      TextSpan(
        text: title.toUpperCase(),
        style: textStyle,
        children: [
          if (warning != null)
            TextSpan(text: warning, style: textStyle.copyWith(fontSize: 10)),
        ],
      ),
    ),
  );
}
