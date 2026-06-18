import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chamo_qr_app/controllers/settings_controller.dart';

/// A utility class for triggering haptic feedback throughout the application.
///
/// It intercepts all haptic requests and checks the user's haptic feedback preference
/// via the [SettingsController] before executing the native system call.
class HapticHelper {
  /// Triggers a light haptic impact.
  ///
  /// Typically used for standard button clicks and light interactive elements.
  /// If [SettingsController] is not registered or throws an exception, this call
  /// defaults to silent (no vibration).
  static void trigger() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.hapticFeedback.value) {
          HapticFeedback.lightImpact();
        }
      }
    } catch (_) {
      // Safe catch-all defaults to silent to respect settings
    }
  }

  /// Triggers a selection click haptic feedback.
  ///
  /// Typically used for toggles, switch changes, and tab selections.
  /// If [SettingsController] is not registered or throws an exception, this call
  /// defaults to silent (no vibration).
  static void selectionClick() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.hapticFeedback.value) {
          HapticFeedback.selectionClick();
        }
      }
    } catch (_) {
      // Safe catch-all defaults to silent to respect settings
    }
  }

  /// Triggers a medium haptic impact.
  ///
  /// Typically used for actions with slightly more weight, like clipboard copies
  /// or intermediate confirmations.
  /// If [SettingsController] is not registered or throws an exception, this call
  /// defaults to silent (no vibration).
  static void mediumImpact() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.hapticFeedback.value) {
          HapticFeedback.mediumImpact();
        }
      }
    } catch (_) {
      // Safe catch-all defaults to silent to respect settings
    }
  }

  /// Triggers a heavy haptic impact.
  ///
  /// Typically used for major actions or destructive events.
  /// If [SettingsController] is not registered or throws an exception, this call
  /// defaults to silent (no vibration).
  static void heavyImpact() {
    try {
      if (Get.isRegistered<SettingsController>()) {
        final settingsController = Get.find<SettingsController>();
        if (settingsController.hapticFeedback.value) {
          HapticFeedback.heavyImpact();
        }
      }
    } catch (_) {
      // Safe catch-all defaults to silent to respect settings
    }
  }
}
