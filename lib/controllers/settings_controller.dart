import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:update_checker_bottom_sheet/update_checker_bottom_sheet.dart';
import '../services/settings_service.dart';

class SettingsController extends GetxController {
  final SettingsService _service;

  SettingsController(this._service);

  // Observables
  var isDarkMode = true.obs;
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
    isDarkMode.value = _service.isDarkMode;
    scanSounds.value = _service.scanSounds;
    hapticFeedback.value = _service.hapticFeedback;
    autoCopy.value = _service.autoCopy;
    autoCheckForUpdates.value = _service.autoCheckUpdates;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _service.setDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleScanSounds(bool value) {
    scanSounds.value = value;
    _service.setScanSounds(value);
  }

  void toggleHapticFeedback(bool value) {
    hapticFeedback.value = value;
    _service.setHapticFeedback(value);
  }

  void toggleAutoCopy(bool value) {
    autoCopy.value = value;
    _service.setAutoCopy(value);
  }

  void toggleAutoCheckUpdates(bool value) {
    autoCheckForUpdates.value = value;
    _service.setAutoCheckUpdates(value);
  }

  void checkForUpdates(BuildContext context) async {
    await UpdateCheckerBottomSheet.checkAndUpdate(
      context,
      showIfUpToDate: true,
      config: UpdateCheckerConfig(
        githubRepo: "jydv402/chamo_qr",
        bottomSheetColors: UpdateBottomSheetColors(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          accentColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
