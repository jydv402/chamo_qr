import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';
import '../services/settings_service.dart';
import '../config/flavor_config.dart';

class SettingsController extends GetxController {
  final SettingsService _service;

  SettingsController(this._service);

  // Observables
  var themeMode = ThemeMode.system.obs;
  var scanSounds = true.obs;
  var hapticFeedback = true.obs;
  var autoCopy = false.obs;
  var autoCheckForUpdates = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    final savedMode = _service.themeMode;
    themeMode.value = ThemeMode.values[savedMode];
    scanSounds.value = _service.scanSounds;
    hapticFeedback.value = _service.hapticFeedback;
    autoCopy.value = _service.autoCopy;
    // Always false if update feature is disabled
    autoCheckForUpdates.value =
        FlavorConfig.isUpdateFeatureEnabled && _service.autoCheckUpdates;
  }

  /// Toggles theme mode.
  ///
  /// ### Params
  /// * `value`: The value to toggle.
  void updateThemeMode() {
    // ThemeMode indices: 0: system, 1: light, 2: dark
    final nextIndex = (themeMode.value.index + 1) % 3;
    final nextMode = ThemeMode.values[nextIndex];

    themeMode.value = nextMode;
    _service.setThemeMode(nextMode.index);
    Get.changeThemeMode(nextMode);
  }

  /// Toggles scan sounds.
  ///
  /// ### Params
  /// * `value`: The value to toggle.
  void toggleScanSounds(bool value) {
    scanSounds.value = value;
    _service.setScanSounds(value);
  }

  /// Toggles haptic feedback.
  ///
  /// ### Params
  /// * `value`: The value to toggle.
  void toggleHapticFeedback(bool value) {
    hapticFeedback.value = value;
    _service.setHapticFeedback(value);
  }

  /// Toggles auto-copy to clipboard.
  ///
  /// ### Params
  /// * `value`: The value to toggle.
  void toggleAutoCopy(bool value) {
    autoCopy.value = value;
    _service.setAutoCopy(value);
  }

  /// Toggles auto-check for updates.
  ///
  /// ### Params
  /// * `value`: The value to toggle.
  void toggleAutoCheckUpdates(bool value) {
    if (!FlavorConfig.isUpdateFeatureEnabled) return;
    autoCheckForUpdates.value = value;
    _service.setAutoCheckUpdates(value);
  }

  /// Checks for updates.
  ///
  /// ### Params
  /// * `context`: The build context.
  /// * `showIfUpToDate`: Whether to show the bottom sheet if the app is up to date.
  void checkForUpdates(BuildContext context, bool showIfUpToDate) async {
    if (!FlavorConfig.isUpdateFeatureEnabled) {
      if (showIfUpToDate) {
        Get.snackbar(
          'Updates Disabled',
          'This version of the app does not support automatic updates.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    await UpdateCheckerBottomSheet.checkAndUpdate(
      context,
      showIfUpToDate: showIfUpToDate,
      config: UpdateCheckerConfig(
        bottomSheetStyles: UpdateBottomSheetStyles(
          showHandle: true,
          showBorder: true,
          borderColor: Colors.grey.withValues(alpha: 0.3),
        ),
        githubRepo: "jydv402/chamo_qr",
        bottomSheetColors: UpdateBottomSheetColors(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          accentColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
