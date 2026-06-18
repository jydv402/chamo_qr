import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chamo_qr_app/elements/build_base_bottom_sheet.dart';
import 'package:chamo_qr_app/theme/app_theme.dart';
import 'package:chamo_qr_app/widgets/confirmation_bottom_sheet.dart';
import 'package:chamo_qr_app/widgets/rename_bottom_sheet.dart';
import 'package:chamo_qr_app/utils/haptic_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/history_controller.dart';
import '../models/qr_code_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ScanResultBottomSheet extends StatefulWidget {
  final QrCodeRecord record;
  const ScanResultBottomSheet({super.key, required this.record});

  @override
  State<ScanResultBottomSheet> createState() => _ScanResultBottomSheetState();
}

class _ScanResultBottomSheetState extends State<ScanResultBottomSheet> {
  late QrCodeRecord _currentRecord;
  final TextEditingController _nameController = TextEditingController();

  QrCodeRecord get record => _currentRecord;

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseBottomSheet(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    _buildTag(
                      record.format,
                      AppTheme.formatColors[record.format] ?? Colors.orange,
                      isDark,
                    ),

                    _buildTag(record.type.toUpperCase(), Colors.blue, isDark),

                    _buildTag(
                      timeago.format(record.timestamp),
                      Colors.green,
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    HapticHelper.light();
                    Get.bottomSheet(
                      RenameBottomSheet(
                        nameController: _nameController,
                        title: _currentRecord.title,
                        onConfirm: () async {
                          // Get new title from controller
                          final newTitle = _nameController.text.trim().isNotEmpty
                              ? _nameController.text.trim()
                              : null;

                          // Update record
                          final updatedRecord = _currentRecord.copyWith(
                            title: newTitle,
                          );

                          // Update state
                          setState(() {
                            _currentRecord = updatedRecord;
                          });

                          // Update history controller
                          if (Get.isRegistered<HistoryController>()) {
                            Get.find<HistoryController>().updateRecord(
                              updatedRecord,
                            );
                          }
                          Get.back();
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        record.title ??
                            (record.type == 'scan'
                                ? 'Scan ${record.id.substring(0, 4)}'
                                : 'Generated ${record.id.substring(0, 4)}'),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit,
                        size: 20,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // QR Image
            GestureDetector(
              onTap: () {
                HapticHelper.light();
                Get.toNamed('/qrDisplay', arguments: record);
              },
              child: SizedBox(
                width: 63,
                height: 63,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: QrImageView(
                    data: record.data,
                    version: QrVersions.auto,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Link Container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey[50],
            border: Border.all(
              color: isDark
                  ? Colors.grey[800]!.withValues(alpha: 0.5)
                  : Colors.grey[100]!,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: isDark ? 0.3 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForFormat(record.format),
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.data,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getLinkSubtext(),
                      style: TextStyle(
                        color: _getLinkSubtextColor(isDark),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.content_copy_rounded, color: Colors.grey[400]),
                onPressed: () {
                  HapticHelper.medium();
                  Clipboard.setData(ClipboardData(text: record.data));
                  Get.snackbar(
                    'Copied',
                    'QR code data copied to clipboard',
                    snackPosition: SnackPosition.TOP,
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    icon: Icon(Icons.done_all_rounded),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Info Cards Grid
        Row(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  final safetyInfo = _getSafetyInfo();
                  return _buildInfoCard(
                    context,
                    icon: safetyInfo.icon,
                    iconColor: safetyInfo.iconColor,
                    title: safetyInfo.title,
                    subtitle: safetyInfo.subtitle,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                context,
                icon: Icons.history_rounded,
                title: 'History',
                subtitle: 'Saved to log',
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Action Buttons
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: record.format == 'URL'
                ? () async {
                    HapticHelper.light();
                    final uri = Uri.parse(record.data);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Could not open URL',
                        snackPosition: SnackPosition.TOP,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        icon: Icon(Icons.error_outline_rounded),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : Colors.black,
              foregroundColor: isDark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: isDark ? 0 : 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  record.format == 'URL'
                      ? 'Open in Browser'
                      : 'Cannot Open Link',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.open_in_new_rounded, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                context,
                icon: Icons.cleaning_services_rounded,
                label: 'Delete',
                onTap: () {
                  HapticHelper.light();
                  Get.bottomSheet(
                    ConfirmationBottomSheet(
                      header: "Delete QR Code",
                      message:
                          "Are you sure you want to delete this QR code from history?",
                      onConfirm: () {
                        if (Get.isRegistered<HistoryController>()) {
                          Get.find<HistoryController>().deleteRecord(
                            _currentRecord.id,
                          );
                        }
                        Get.back();
                        Get.back();
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryButton(
                context,
                icon: Icons.share_rounded,
                label: 'Share',
                onTap: () {
                  HapticHelper.medium();
                  SharePlus.instance.share(
                    ShareParams(
                      text: record.data,
                      subject: 'Shared via Chamo QR',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.3 : 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? color.withValues(alpha: 0.9) : color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'GSansFlex',
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[800]!.withValues(alpha: 0.5)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? Colors.grey[400], size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[100],
          foregroundColor: isDark ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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

  IconData _getIconForFormat(String format) {
    switch (format.toLowerCase()) {
      case 'url':
        return Icons.link;
      case 'wi-fi':
        return Icons.wifi;
      case 'contact':
        return Icons.contact_page;
      case 'text':
      default:
        return Icons.text_fields;
    }
  }

  // Helper methods

  /// Returns the subtext for the link
  /// Checks if the link starts with https:// or http://
  /// Returns 'Secure Connection • HTTPS' if the link starts with https://
  /// Returns 'Insecure Connection • HTTP' if the link starts with http://
  /// Returns 'Link to visit' if the link starts with anything else
  String _getLinkSubtext() {
    if (record.format == 'URL') {
      if (record.data.toLowerCase().startsWith('https://')) {
        return 'Secure Connection • HTTPS';
      } else if (record.data.toLowerCase().startsWith('http://')) {
        return 'Insecure Connection • HTTP';
      }
      return 'Link to visit';
    }
    return 'Raw Data Extract';
  }

  /// Returns the color for the link subtext
  /// Checks if the link starts with https:// or http://
  /// Returns green if the link starts with https://
  /// Returns orange if the link starts with http://
  /// Returns grey if the link starts with anything else
  Color _getLinkSubtextColor(bool isDark) {
    if (record.format == 'URL') {
      if (record.data.toLowerCase().startsWith('https://')) {
        return isDark ? Colors.green[400]! : Colors.green[600]!;
      } else if (record.data.toLowerCase().startsWith('http://')) {
        return isDark ? Colors.orange[400]! : Colors.orange[600]!;
      }
    }
    return isDark ? Colors.grey[400]! : Colors.grey[500]!;
  }

  /// Returns the safety info for the link
  /// Checks if the link starts with https:// or http://
  _SafetyInfo _getSafetyInfo() {
    if (record.format == 'URL') {
      final isHttps = record.data.toLowerCase().startsWith('https://');
      if (isHttps) {
        return _SafetyInfo(
          icon: Icons.gpp_good,
          iconColor: Colors.green,
          title: 'Secure',
          subtitle: 'Encrypted traffic',
        );
      } else {
        return _SafetyInfo(
          icon: Icons.gpp_maybe,
          iconColor: Colors.orange,
          title: 'Insecure',
          subtitle: 'Unencrypted traffic',
        );
      }
    } else {
      return _SafetyInfo(
        icon: Icons.offline_pin,
        iconColor: Colors.blue,
        title: 'Offline',
        subtitle: 'No web threats',
      );
    }
  }
}

class _SafetyInfo {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  _SafetyInfo({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}
