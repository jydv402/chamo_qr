import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chamo_qr_app/utils/haptic_helper.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/qr_scanner_controller.dart';
import '../widgets/scan_frame.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the scanner controller that will be active while this screen is built
    final QrScannerController controller = Get.put(QrScannerController());

    return Scaffold(
      backgroundColor: Colors.black, // Dark background for camera
      body: Stack(
        children: [
          // Camera View
          Positioned.fill(
            child: MobileScanner(
              controller: controller.mobileController,
              onDetect: controller.handleBarcode,
            ),
          ),

          // Background dimming around the scanner hole (simulated here via a gradient/color overlay)
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),

          // Top Bar (Title and Options)
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scanner',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Text(
                      'Point at a QR code',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'GSansFlex',
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      HapticHelper.trigger();
                      Get.toNamed('/settings');
                    },
                  ),
                ),
              ],
            ),
          ),

          // Scanner Frame
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => AnimatedScannerFrame(
                    isScanning: controller.isScanning.value,
                  ),
                ),
                const SizedBox(height: 48),
                // Flash and Gallery Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => _buildActionButton(
                        icon: controller.isTorchOn.value
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        label: 'Flash',
                        onTap: () => controller.toggleTorch(),
                      ),
                    ),
                    const SizedBox(width: 32),
                    _buildActionButton(
                      icon: Icons.image,
                      label: 'Gallery',
                      onTap: () => controller.scanFromGallery(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            HapticHelper.trigger();
            onTap();
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'GSansFlex',
          ),
        ),
      ],
    );
  }
}
