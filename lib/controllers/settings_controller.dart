import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';
import '../services/settings_service.dart';

class SettingsController extends GetxController {
  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: 'null:debug',
  );

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
    autoCheckForUpdates.value = _service.autoCheckUpdates;
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
    autoCheckForUpdates.value = value;
    _service.setAutoCheckUpdates(value);
  }

  /// Checks for updates.
  ///
  /// ### Params
  /// * `context`: The build context.
  /// * `showIfUpToDate`: Whether to show the bottom sheet if the app is up to date.
  void checkForUpdates(BuildContext context, bool showIfUpToDate) async {
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

  /// Share app with others
  /// Opens share sheet with the message to send to others
  void shareApp() {
    const String shareMsg =
        "Hi there,\nCheck out Chamo QR🦎!\n\nIt's a super fast and beautiful QR scanner and generator I've been using. Makes handling QR codes so much easier.\n\n"
        "Explore the project: https://github.com/jydv402/chamo_qr\n\n"
        "Get the latest app: https://github.com/jydv402/chamo_qr/releases/latest";

    SharePlus.instance.share(
      ShareParams(subject: "Share Chamo QR with others", text: shareMsg),
    );
  }
}
