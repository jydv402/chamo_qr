import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chamo_qr_app/utils/haptic_helper.dart';
import '../controllers/qr_scanner_controller.dart';
import '../widgets/glitter_overlay.dart';

class GalleryScanScreen extends StatefulWidget {
  final String imagePath;

  const GalleryScanScreen({super.key, required this.imagePath});

  @override
  State<GalleryScanScreen> createState() => _GalleryScanScreenState();
}

class _GalleryScanScreenState extends State<GalleryScanScreen> {
  bool _isScanning = false;
  final QrScannerController _scannerController =
      Get.find<QrScannerController>();

  Future<void> _performScan() async {
    setState(() {
      _isScanning = true;
    });

    // Artificial delay to show off the beautiful glittering effect as requested
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final capture = await _scannerController.mobileController.analyzeImage(
        widget.imagePath,
      );

      if (capture != null && capture.barcodes.isNotEmpty) {
        // Found QR code(s) - Stop animation immediately
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
        }

        await _scannerController.handleBarcode(capture);
      } else {
        // No QR found - Stop animation
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
        }
        Get.snackbar(
          'No QR Code Found',
          'We couldn\'t find any QR code in this image.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
      Get.snackbar(
        'Error',
        'An error occurred while scanning the image.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The Image (Centered)
          Align(
            alignment: Alignment.center,
            child: GlitterOverlay(
              isAnimating: _isScanning,
              child: Hero(
                tag: widget.imagePath,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),

          // Top Bar (Back Button and Animated Header)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        HapticHelper.trigger();
                        Get.back();
                      },
                    ),
                  ),
                  if (_isScanning)
                    const Text(
                      'Scanning...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'GSansFlex',
                      ),
                    )
                  else
                    const SizedBox(width: 48), // Spacer for centering
                  const SizedBox(width: 48), // Balancer for centering
                ],
              ),
            ),
          ),

          // Bottom Scan Button
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isScanning)
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        HapticHelper.trigger();
                        _performScan();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Scan QR Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GSansFlex',
                        ),
                      ),
                    ),
                  )
                else
                  const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Scanning for QR codes...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'GSansFlex',
                        ),
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
}
