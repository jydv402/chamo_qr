import 'package:chamo_qr_app/elements/build_section_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chamo_qr_app/elements/build_divider.dart';
import 'package:chamo_qr_app/widgets/confirmation_bottom_sheet.dart';
import 'package:chamo_qr_app/controllers/history_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chamo_qr_app/elements/build_section_header.dart';
import 'package:chamo_qr_app/elements/build_navigation_row.dart';
import 'package:chamo_qr_app/controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'GSansFlex',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          // App Info Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.75,
                    heightFactor: 0.75,
                    child: Image.asset('assets/branding/chamo_fore.png'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Chamo QR',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Version 1.0.5',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The simplest way to scan, create, and manage QR codes. Fast, secure, and privacy-focused.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Scanner Preferences
          buildSectionHeader(context, 'Scanner Preferences', null),
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
                Obx(
                  () => _buildToggleRow(
                    context,
                    icon: Icons.vibration,
                    label: 'Vibrate on Scan',
                    value: settingsController.hapticFeedback.value,
                    onChanged: (val) =>
                        settingsController.toggleHapticFeedback(val),
                  ),
                ),
                buildDivider(context),
                Obx(
                  () => _buildToggleRow(
                    context,
                    icon: Icons.volume_up,
                    label: 'Beep on Scan',
                    value: settingsController.scanSounds.value,
                    onChanged: (val) =>
                        settingsController.toggleScanSounds(val),
                  ),
                ),
                buildDivider(context),
                Obx(
                  () => _buildToggleRow(
                    context,
                    icon: Icons.content_copy,
                    label: 'Auto-Copy to Clipboard',
                    value: settingsController.autoCopy.value,
                    onChanged: (val) => settingsController.toggleAutoCopy(val),
                  ),
                ),
              ],
            ),
          ),

          // App Settings
          buildSectionHeader(context, 'App Settings', null),
          buildSectionContainer(
            context,
            Column(
              children: [
                Obx(
                  () => buildNavigationRow(
                    context,
                    icon: Icons.palette_rounded,
                    label: 'Theme',
                    valueText: settingsController
                        .themeMode
                        .value
                        .name
                        .capitalizeFirst!,
                    onTap: () => settingsController.updateThemeMode(),
                  ),
                ),
              ],
            ),
            isDark,
          ),

          // Data settings
          buildSectionHeader(context, 'Data', null),
          buildSectionContainer(
            context,
            Column(
              children: [
                buildNavigationRow(
                  context,
                  icon: Icons.file_upload_rounded,
                  label: 'Export to JSON',
                  onTap: () => Get.find<HistoryController>().exportHistory(),
                ),
                buildDivider(context),
                buildNavigationRow(
                  context,
                  icon: Icons.file_download_rounded,
                  label: 'Import from JSON',
                  onTap: () => Get.find<HistoryController>().importHistory(),
                ),
                buildDivider(context),
                buildNavigationRow(
                  context,
                  icon: Icons.history,
                  label: 'Clear History',
                  onTap: () => Get.bottomSheet(
                    ConfirmationBottomSheet(
                      header: "Clear History",
                      message:
                          "Are you sure you want to clear your history?\n\nThis clears all scanned and generated QR data and is irreversible.",
                      onConfirm: () =>
                          Get.find<HistoryController>().clearHistory(),
                    ),
                  ),
                ),
              ],
            ),
            isDark,
          ),

          // Updates Section
          buildSectionHeader(context, 'Updates', null),
          buildSectionContainer(
            context,
            Column(
              children: [
                Obx(
                  () => _buildToggleRow(
                    context,
                    icon: Icons.refresh_rounded,
                    label: "Auto check for updates",
                    value: settingsController.autoCheckForUpdates.value,
                    onChanged: (val) {
                      settingsController.toggleAutoCheckUpdates(val);
                    },
                  ),
                ),
                buildDivider(context),
                buildNavigationRow(
                  context,
                  icon: Icons.upload_rounded,
                  label: 'Check for updates',
                  onTap: () =>
                      settingsController.checkForUpdates(context, true),
                ),
              ],
            ),
            isDark,
          ),

          // Support Settings
          buildSectionHeader(context, 'Support', null),
          buildSectionContainer(
            context,
            buildNavigationRow(
              context,
              icon: Icons.star_rounded,
              label: 'Star the project',
              onTap: () => Get.bottomSheet(
                ConfirmationBottomSheet(
                  header: "Star the project",
                  message:
                      "If you like Chamo QR, please consider giving it a star on GitHub and support the project!\n\nAlso helps you to get latest updates about the project.\n\nConfirm to proceed to GitHub?",
                  onConfirm: () {
                    launchUrl(Uri.parse("https://github.com/jydv402/chamo_qr"));
                  },
                ),
              ),
            ),
            isDark,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Builds a toggle row for a setting.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [icon]: The icon to display.
  /// - [label]: The label to display.
  /// - [value]: The current value of the setting.
  /// - [onChanged]: The callback to call when the value changes.
  Widget _buildToggleRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
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
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: isDark
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.2),
            thumbIcon: WidgetStatePropertyAll(
              Icon(
                value ? Icons.check_rounded : Icons.close_rounded,
                color: value
                    ? Colors.black
                    : isDark
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
