import 'package:get/get.dart';
import '../screens/qr_display.dart';
import '../screens/main_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/gallery_scan_screen.dart';

class AppRoutes {
  static const String main = '/';
  static const String settings = '/settings';
  static const String qrDisplay = '/qrDisplay';
  static const String galleryScan = '/galleryScan';

  static final routes = [
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    GetPage(name: qrDisplay, page: () => QrDisplayScreen()),
    GetPage(
      name: galleryScan,
      page: () => GalleryScanScreen(imagePath: Get.arguments as String),
      transition: Transition.fadeIn,
    ),
  ];
}
