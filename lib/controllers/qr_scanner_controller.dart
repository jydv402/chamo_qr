import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/qr_code_model.dart';
import 'history_controller.dart';
import 'package:uuid/uuid.dart';
import '../widgets/scan_result_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'settings_controller.dart';
import 'bottom_nav_controller.dart';

class QrScannerController extends GetxController {
  final MobileScannerController mobileController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
    autoStart: false,
  );

  // Observable variables
  var isTorchOn = false.obs; //Turn on the flashlight
  var isScanning = true.obs; //Status of scan. True => Scanning, False => Paused

  // Controllers
  final HistoryController _historyController = Get.find();
  final SettingsController _settingsController = Get.find();
  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();

    // Listen to tab changes to pause/resume the camera and save resources
    if (Get.isRegistered<BottomNavController>()) {
      final BottomNavController bottomNavController = Get.find();

      // Check initial state on app launch and start the camera if we default to the scanner tab
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (bottomNavController.currentIndex.value == 0) {
          resumeScanning();
        } else {
          isScanning.value = false;
        }
      });

      ever(bottomNavController.currentIndex, (int index) {
        if (index == 0) {
          // Navigated back to Scanner tab
          resumeScanning();
        } else {
          // Navigated away from Scanner tab
          isScanning.value = false;
          mobileController.stop();
        }
      });
    }
  }

  // Dispose the controller when the screen is closed
  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }

  // Toggle the torch
  void toggleTorch() {
    mobileController.toggleTorch();
    isTorchOn.toggle();
  }

  // Handle barcode detection
  Future<void> handleBarcode(BarcodeCapture capture) async {
    if (!isScanning.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      final String rawValue = barcode.rawValue ?? '';

      if (rawValue.isNotEmpty) {
        // Pause to prevent multiple detections of the same code
        isScanning.value = false;
        mobileController.stop();

        // Provide haptic feedback
        if (_settingsController.hapticFeedback.value) {
          Vibration.hasVibrator().then((hasVibrator) {
            if (hasVibrator == true) {
              Vibration.vibrate(duration: 50);
            }
          });
        }

        // Provide sound feedback
        if (_settingsController.scanSounds.value) {
          FlutterRingtonePlayer().play(
            fromAsset: 'assets/sounds/scan_ping.mp3',
          );
        }

        // Determine format roughly
        String format = 'Text';
        if (rawValue.startsWith('http://') || rawValue.startsWith('https://')) {
          format = 'URL';
        } else if (rawValue.startsWith('WIFI:')) {
          format = 'Wi-Fi';
        } else if (rawValue.startsWith('BEGIN:VCARD')) {
          format = 'Contact';
        }
        // TODO: Add upi

        // Save to history and get the canonical record
        final record = QrCodeRecord(
          id: _uuid.v4(),
          data: rawValue,
          type: 'scan',
          format: format,
          timestamp: DateTime.now(),
        );
        final savedRecord = await _historyController.addRecord(record);

        // Auto Copy hook. Works only if auto-copy is enabled in settings
        if (_settingsController.autoCopy.value) {
          Clipboard.setData(ClipboardData(text: rawValue));
          Get.snackbar(
            'Copied',
            'Data auto-copied to clipboard',
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
            icon: Icon(Icons.done_all_rounded),
          );
        }

        // Show Bottom Sheet here with deduplicated record
        await Get.bottomSheet(
          ScanResultBottomSheet(record: savedRecord),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );

        // Resume scanning after bottom sheet is dismissed
        resumeScanning();
      }
    }
  }

  // Scan codes from images selected from Gallery
  Future<void> scanFromGallery() async {
    // Open the gallery and obtain the image picked by the user
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      // User cancelled the picker
      return;
    }

    // Navigate to the Gallery Scan Screen
    Get.toNamed('/galleryScan', arguments: image.path);
  }

  void resumeScanning() {
    isScanning.value = true;
    mobileController.start();
  }
}
