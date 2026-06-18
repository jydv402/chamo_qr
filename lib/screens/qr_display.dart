import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:chamo_qr_app/utils/haptic_helper.dart';
import 'package:chamo_qr_app/elements/build_divider.dart';
import 'package:chamo_qr_app/elements/build_navigation_row.dart';
import 'package:chamo_qr_app/elements/build_section_header.dart';
import 'package:chamo_qr_app/models/qr_code_model.dart';
import 'package:chamo_qr_app/utils/image_utils.dart';
import 'package:chamo_qr_app/widgets/confirmation_bottom_sheet.dart';
import 'package:chamo_qr_app/widgets/details_bottom_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class QrDisplayScreen extends StatelessWidget {
  late final QrCodeRecord? _record;

  QrDisplayScreen({super.key}) {
    _record = Get.arguments as QrCodeRecord?;
  }

  @override
  Widget build(BuildContext context) {
    // Get the theme data
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    // Get the arguments from the directed page
    final record = _record;

    if (record == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              HapticHelper.trigger();
              Get.back();
            },
          ),
        ),
        body: const Center(child: Text('Error: No QR code data found')),
      );
    }

    // Ontain the screen size
    final size = Get.width * 0.9;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          record.title ??
              "${record.type.toUpperCase()} ${record.id.substring(0, 4)}",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'GSansFlex',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            HapticHelper.trigger();
            Get.back();
          },
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          // QR Code Section
          const SizedBox(height: 16),
          buildSectionHeader(context, 'QR Code', null),
          Center(
            child: SizedBox(
              width: size,
              height: size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: QrImageView(
                  data: record.data,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Options Section
          buildSectionHeader(context, 'options', null),
          Container(
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
            child: Column(
              children: [
                buildNavigationRow(
                  context,
                  icon: Icons.download_rounded,
                  label: "Save to Gallery",
                  onTap: () => Get.bottomSheet(
                    ConfirmationBottomSheet(
                      header: 'Save to Gallery',
                      message:
                          'Are you sure you want to save this QR code to your gallery?',
                      onConfirm: () {
                        // Call the save to gallery function
                        ImageUtils.saveQrToGallery(record.data, record.title);
                      },
                    ),
                  ),
                ),
                buildDivider(context),
                buildNavigationRow(
                  context,
                  icon: Icons.share_rounded,
                  label: "Share as image",
                  onTap: () {
                    // Call the share as image function
                    ImageUtils.shareQrImage(record.data);
                  },
                ),
                buildDivider(context),
                buildNavigationRow(
                  context,
                  icon: Icons.info_outline_rounded,
                  label: "Details",
                  onTap: () {
                    Get.bottomSheet(
                      DetailsBottomSheet(
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildDetailsSection(
                                  context,
                                  record,
                                  size,
                                  isDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isScrollControlled: true,
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: size * 0.5),
        ],
      ),
    );
  }

  List<Widget> _buildDetailsSection(
    BuildContext context,
    QrCodeRecord record,
    double size,
    bool isDark,
  ) {
    return [
      const SizedBox(height: 16),

      // Title Section
      buildSectionHeader(context, 'title', ' [Selectable Text]'),
      buildDataPill(
        context,
        record.title ??
            "${record.type.toUpperCase()} ${record.id.substring(0, 4)}",
        size,
        isDark,
      ),

      const SizedBox(height: 16),

      // Raw Data Section
      buildSectionHeader(context, 'raw data', ' [Selectable Text]'),
      buildDataPill(context, record.data, size, isDark),

      const SizedBox(height: 16),

      // Time Stamp
      buildSectionHeader(context, 'time stamp', null),
      buildDataPill(
        context,
        "${DateFormat.yMMMMd().format(record.timestamp)} @ ${DateFormat.jm().format(record.timestamp)}",
        size,
        isDark,
      ),
    ];
  }

  Widget buildDataPill(
    BuildContext context,
    String data,
    double size,
    bool isDark,
  ) {
    return Container(
      width: size,
      alignment: .centerStart,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
      padding: const EdgeInsets.all(24),
      child: SelectableText(
        data,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: .w500),
      ),
    );
  }
}
