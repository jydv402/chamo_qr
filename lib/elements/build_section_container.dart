import 'package:flutter/material.dart';

Widget buildSectionContainer(BuildContext context, Widget child, bool isDark) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        if (!isDark)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
      ],
    ),
    child: child,
  );
}
