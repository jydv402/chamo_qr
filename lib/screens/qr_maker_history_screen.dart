import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chamo_qr_app/utils/haptic_helper.dart';
import 'package:chamo_qr_app/controllers/bottom_nav_controller.dart';
import 'package:chamo_qr_app/theme/app_theme.dart';
import 'package:chamo_qr_app/widgets/history_item.dart';
import '../controllers/qr_maker_controller.dart';
import '../controllers/history_controller.dart';
import '../widgets/scan_result_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class QrMakerHistoryScreen extends StatelessWidget {
  const QrMakerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    final QrMakerController makerController = Get.put(QrMakerController());
    final HistoryController historyController = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 18,
                bottom: 18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Chamo QR',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Create and scan QR codes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'GSansFlex',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                      onPressed: () {
                        HapticHelper.trigger();
                        Get.toNamed('/settings');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Main Details (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 120,
                ),

                children: [
                  // New Code Card
                  _buildNewCodeCard(context, makerController),

                  const SizedBox(height: 8),

                  // History Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Previously Created',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticHelper.selectionClick();
                          // Change the index to 2 to goto history screen
                          Get.find<BottomNavController>().changeIndex(2);
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontFamily: 'GSansFlex',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // History List Items
                  Obx(() {
                    if (historyController.generatedHistory.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'No generated QR codes yet.',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: 'GSansFlex',
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      // Show only 3 of the previous history items
                      children: historyController.generatedHistory.take(3).map((
                        record,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              HapticHelper.trigger();
                              Get.bottomSheet(
                                ScanResultBottomSheet(record: record),
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                              );
                            },
                            child: HistoryItem(
                              title:
                                  record.title ??
                                  'Generated ${record.id.substring(0, 4)}', // Main title of tile
                              subtitle: record.data, // Data of the QR
                              format: record.format, // Format of the QR
                              type: record
                                  .type, // Type of the QR, scanned or generated
                              time: timeago.format(record.timestamp),
                              formatColor:
                                  AppTheme.formatColors[record.format] ??
                                  Colors.orange,
                              typeColor: Colors.blue,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  // Text to inform this only shows the last 2 history items
                  if (historyController.generatedHistory.isNotEmpty &&
                      historyController.generatedHistory.length > 3)
                    const Text(
                      'Only the last 3 history items are shown here.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'GSansFlex',
                      ),
                      textAlign: .center,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCodeCard(BuildContext context, QrMakerController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.qr_code_2,
                  color: isDark ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),

              Text(
                'Generate Code',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Input Field (Data)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller.textController,
              focusNode: controller.focusNode1,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                icon: Icon(Icons.link, color: Colors.grey[400]),
                hintText: 'Enter QR content',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'GSansFlex',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Input Field (Title)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: controller.titleController,
              focusNode: controller.focusNode2,
              decoration: InputDecoration(
                icon: Icon(Icons.title, color: Colors.grey[400]),
                hintText: 'Name (Optional)',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'GSansFlex',
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Type Selectors
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildTypeSelector(
                    context,
                    'URL',
                    Icons.link,
                    isSelected: controller.selectedType.value == 'URL',
                    onTap: () => controller.setType('URL'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeSelector(
                    context,
                    'Wi-Fi',
                    Icons.wifi,
                    isSelected: controller.selectedType.value == 'Wi-Fi',
                    onTap: () => controller.setType('Wi-Fi'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeSelector(
                    context,
                    'Text',
                    Icons.text_fields,
                    isSelected: controller.selectedType.value == 'Text',
                    onTap: () => controller.setType('Text'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTypeSelector(
                    context,
                    'VCard',
                    Icons.contact_page,
                    isSelected: controller.selectedType.value == 'VCard',
                    onTap: () => controller.setType('VCard'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Generate Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isGenerating.value
                    ? null
                    : () {
                        HapticHelper.trigger();
                        controller.generateQrCode();
                        controller.focusNode1.unfocus();
                        controller.focusNode2.unfocus();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isDark ? 0 : 4,
                  shadowColor: Colors.black.withValues(alpha: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Generate QR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GSansFlex',
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build type selector widget
  /// Used in the QR maker screen
  /// Build the small toggles for URL, Wi-Fi, Text, VCard
  Widget _buildTypeSelector(
    BuildContext context,
    String label,
    IconData icon, {
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bgColor;
    Color iconColor;

    if (isSelected) {
      bgColor = isDark ? Colors.white : Theme.of(context).primaryColor;
      iconColor = isDark ? Colors.black : Colors.white;
    } else {
      bgColor = isDark ? Colors.grey[800]! : Colors.grey[50]!;
      iconColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;
    }

    return GestureDetector(
      onTap: () {
        HapticHelper.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected && !isDark
              ? [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: iconColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                fontFamily: 'GSansFlex',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
