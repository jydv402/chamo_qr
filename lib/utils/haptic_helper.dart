import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chamo_qr_app/controllers/settings_controller.dart';

/// A utility class for triggering native haptic feedback throughout the application.
///
/// It checks the user's haptic feedback preference via [SettingsController]
/// before triggering native vibrations.
class HapticHelper {
  /// Triggers a light haptic impact.
  ///
  /// Typically used for standard button clicks, toggles, switches, and tabs.
  static void light() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.hapticFeedback.value) {
          HapticFeedback.lightImpact();
        }
      }
    } catch (_) {
      // Safe catch-all defaults to silent
    }
  }

  /// Triggers a medium haptic impact.
  ///
  /// Typically used for non-destructive actions with moderate weight, such as
  /// copying text, sharing data, and importing/exporting files.
  static void medium() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.hapticFeedback.value) {
          HapticFeedback.mediumImpact();
        }
      }
    } catch (_) {
      // Safe catch-all defaults to silent
    }
  }

  /// Triggers a heavy haptic impact.
  ///
  /// Typically used for major or destructive actions, such as deleting items
  /// or clearing entire database history logs.
  static void heavy() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.hapticFeedback.value) {
          HapticFeedback.heavyImpact();
        }
      }
    } catch (_) {
      // Safe catch-all defaults to silent
    }
  }
}
