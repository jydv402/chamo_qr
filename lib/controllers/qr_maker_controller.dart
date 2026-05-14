import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/qr_code_model.dart';
import '../controllers/history_controller.dart';
import 'package:uuid/uuid.dart';
import '../widgets/scan_result_bottom_sheet.dart';

class QrMakerController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final HistoryController _historyController = Get.find();
  final _uuid = const Uuid();

  var selectedType = 'URL'.obs;
  var isGenerating = false.obs;

  @override
  void onClose() {
    textController.dispose();
    titleController.dispose();
    super.onClose();
  }

  void setType(String type) {
    selectedType.value = type;
  }

  Future<void> generateQrCode() async {
    final text = textController.text.trim();
    if (text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter some data to generate a QR code.',
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
        icon: Icon(Icons.error_outline_rounded),
      );
      return;
    }

    isGenerating.value = true;

    // Format based on selected type
    String data = text;
    if (selectedType.value == 'URL' && !text.startsWith('http')) {
      data = 'https://$text';
    } else if (selectedType.value == 'Wi-Fi') {
      // Very basic wifi formatting fallback if user just enters network name
      if (!text.startsWith('WIFI:')) {
        data = 'WIFI:S:$text;T:WPA;P:;;';
      }
    }

    final record = QrCodeRecord(
      id: _uuid.v4(),
      title: titleController.text.trim().isNotEmpty
          ? titleController.text.trim()
          : null,
      data: data,
      type: 'generate',
      format: selectedType.value,
      timestamp: DateTime.now(),
    );

    final savedRecord = await _historyController.addRecord(record);
    isGenerating.value = false;

    // Show success and move to history or pop up
    // Show the bottom sheet with the generated code
    await Get.bottomSheet(
      ScanResultBottomSheet(record: savedRecord),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    textController.clear();
    titleController.clear();
  }
}
