import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ImageUtils {
  /// Converts a QR code string data into a high-res PNG image byte array.
  static Future<Uint8List> _generateQrImageBytes(String data) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: ui.Color(0xFF000000),
      ),
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: ui.Color(0xFF000000),
      ),
    );

    const double padding = 51.2;
    const double imageSize = 1024.0;
    const double qrSize = imageSize - (padding * 2);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    // Draw white background
    final bgPaint = ui.Paint()..color = const ui.Color(0xFFFFFFFF);
    canvas.drawRect(
      const ui.Rect.fromLTWH(0, 0, imageSize, imageSize),
      bgPaint,
    );

    // Translate canvas for padding
    canvas.translate(padding, padding);

    // Draw QR code onto canvas
    painter.paint(canvas, const ui.Size(qrSize, qrSize));

    // Convert to image
    final picture = recorder.endRecording();
    final image = await picture.toImage(imageSize.toInt(), imageSize.toInt());

    // Convert to PNG bytes
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to generate QR Image');
    }
    return byteData.buffer.asUint8List();
  }

  /// Saves the QR code represented by [data] to the device gallery.
  static Future<void> saveQrToGallery(String data, String? fileName) async {
    try {
      final bytes = await _generateQrImageBytes(data);

      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        name: fileName ?? 'Chamo_QR_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result != null && result['isSuccess'] == true) {
        Get.snackbar(
          'Saved to Gallery',
          'The QR code was successfully saved to your device.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception('Save failed');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not save image: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// Shares the QR code represented by [data] to other apps.
  static Future<void> shareQrImage(String data, {String? subject}) async {
    try {
      final bytes = await _generateQrImageBytes(data);

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_chamo_qr.png').create();

      // Write bytes to file
      await file.writeAsBytes(bytes);

      // Share file
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text:
              subject ??
              'Check out this QR Code!\n\nGenerated with Chamo QR\nhttps://github.com/jydv402/chamo_qr',
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not share image: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
