import 'package:flutter/material.dart';
import 'package:chamo_qr_app/elements/build_base_bottom_sheet.dart';

class DetailsBottomSheet extends StatelessWidget {
  final List<Widget> children;
  const DetailsBottomSheet({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      children: [
        Text(
          'Details',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
