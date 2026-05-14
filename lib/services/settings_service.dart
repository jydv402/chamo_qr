import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferences _prefs;

  Future<SettingsService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // --- Keys ---
  static const String _themeModeKey = 'theme_mode';
  static const String _scanSoundsKey = 'scan_sounds';
  static const String _hapticFeedbackKey = 'haptic_feedback';
  static const String _autoCopyKey = 'auto_copy';
  static const String _autoCheckUpdatesKey = 'auto_check_updates';

  // --- Getters ---
  int get themeMode => _prefs.getInt(_themeModeKey) ?? 0;

  bool get scanSounds =>
      _prefs.getBool(_scanSoundsKey) ?? true; // Default to true

  bool get hapticFeedback =>
      _prefs.getBool(_hapticFeedbackKey) ?? true; // Default to true

  bool get autoCopy =>
      _prefs.getBool(_autoCopyKey) ?? false; // Default to false

  bool get autoCheckUpdates =>
      _prefs.getBool(_autoCheckUpdatesKey) ?? false; // Default to false

  // --- Setters ---
  Future<void> setThemeMode(int value) async {
    await _prefs.setInt(_themeModeKey, value);
  }

  Future<void> setScanSounds(bool value) async {
    await _prefs.setBool(_scanSoundsKey, value);
  }

  Future<void> setHapticFeedback(bool value) async {
    await _prefs.setBool(_hapticFeedbackKey, value);
  }

  Future<void> setAutoCopy(bool value) async {
    await _prefs.setBool(_autoCopyKey, value);
  }

  Future<void> setAutoCheckUpdates(bool value) async {
    await _prefs.setBool(_autoCheckUpdatesKey, value);
  }
}
