class FlavorConfig {
  /// Whether the current build is for F-Droid.
  /// 
  /// This is determined by the `--dart-define=IS_FDROID=true` flag during build.
  static const bool isFdroid = bool.fromEnvironment('IS_FDROID', defaultValue: false);

  /// Whether the auto-update feature should be enabled.
  static const bool isUpdateFeatureEnabled = !isFdroid;
}
