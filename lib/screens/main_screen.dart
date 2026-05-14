import 'package:chamo_qr_app/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';
import 'qr_scanner_screen.dart';
import 'qr_maker_history_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import 'scan_saved_history_screen.dart';
import '../config/flavor_config.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Initialize controller
  final BottomNavController controller = Get.put(BottomNavController());

  @override
  void initState() {
    super.initState();

    // Check for updates on init if feature is enabled
    if (FlavorConfig.isUpdateFeatureEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final SettingsController settingsController =
            Get.find<SettingsController>();
        if (settingsController.autoCheckForUpdates.value) {
          settingsController.checkForUpdates(context, false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const QrScannerScreen(),
      const QrMakerHistoryScreen(),
      const ScanSavedHistoryScreen(), // Example mapping to history button
    ];

    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // The current active page
            IndexedStack(index: controller.currentIndex.value, children: pages),

            // Floating bottom navigation bar
            const Positioned(
              bottom: 52.0,
              left: 0,
              right: 0,
              child: BottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
