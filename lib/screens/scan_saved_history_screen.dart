import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chamo_qr_app/widgets/history_item.dart';
import '../controllers/history_controller.dart';
import '../widgets/scan_result_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:chamo_qr_app/theme/app_theme.dart';

class ScanSavedHistoryScreen extends StatefulWidget {
  const ScanSavedHistoryScreen({super.key});

  @override
  State<ScanSavedHistoryScreen> createState() => _ScanSavedHistoryScreenState();
}

class _ScanSavedHistoryScreenState extends State<ScanSavedHistoryScreen> {
  bool _isScannedTab = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 18,
                bottom: 4,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                // Header Title
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'History',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Scanned & Generated history',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'GSansFlex',
                        ),
                      ),
                    ],
                  ),
                  // Settings Icon button
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
                        Get.toNamed('/settings');
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  // Swipe right to go to generated tab
                  if (details.primaryVelocity! > 0) {
                    setState(() => _isScannedTab = true);
                  } else {
                    setState(() => _isScannedTab = false);
                  }
                },
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 120,
                  ),
                  children: [
                    // Custom Tab Bar (Scanned / Saved)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isScannedTab = true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _isScannedTab
                                      ? (isDark ? Colors.white : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: _isScannedTab && !isDark
                                      ? [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Scanned',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'GSansFlex',
                                      color: _isScannedTab
                                          ? (isDark
                                                ? Colors.black
                                                : Colors.black)
                                          : (isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _isScannedTab = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isScannedTab
                                      ? (isDark ? Colors.white : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: !_isScannedTab && !isDark
                                      ? [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Generated',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'GSansFlex',
                                      color: !_isScannedTab
                                          ? (isDark
                                                ? Colors.black
                                                : Colors.black)
                                          : (isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Lists matching mockup grouped by dates
                    const SizedBox(height: 8),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _isScannedTab
                          ? _buildScannedList(context)
                          : _buildSavedList(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedList(BuildContext context) {
    final HistoryController historyController = Get.find<HistoryController>();
    return Obx(() {
      if (historyController.scannedHistory.isEmpty) {
        return Column(
          key: const ValueKey('scanned'),
          children: const [
            SizedBox(height: 60),
            Center(child: Text('No scanned items yet.')),
          ],
        );
      }
      return Column(
        key: const ValueKey('scanned'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: historyController.scannedHistory.map((record) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  ScanResultBottomSheet(record: record),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              child: HistoryItem(
                title: record.title ?? 'Scan ${record.id.substring(0, 4)}',
                subtitle: record.data,
                format: record.format,
                type: record.type,
                time: timeago.format(record.timestamp),
                formatColor:
                    AppTheme.formatColors[record.format] ?? Colors.orange,
                typeColor: Colors.blue,
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSavedList(BuildContext context) {
    final HistoryController historyController = Get.find<HistoryController>();
    return Obx(() {
      if (historyController.generatedHistory.isEmpty) {
        return Column(
          key: const ValueKey('saved'),
          children: const [
            SizedBox(height: 60),
            Center(child: Text('No generated items yet.')),
          ],
        );
      }
      return Column(
        key: const ValueKey('saved'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: historyController.generatedHistory.map((record) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  ScanResultBottomSheet(record: record),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              child: HistoryItem(
                title: record.title ?? 'Generated ${record.id.substring(0, 4)}',
                subtitle: record.data,
                format: record.format,
                type: record.type,
                time: timeago.format(record.timestamp),
                formatColor:
                    AppTheme.formatColors[record.format] ?? Colors.orange,
                typeColor: Colors.blue,
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
