import 'dart:convert';
import 'dart:io';

import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:get/get.dart';
import '../models/qr_code_model.dart';
import '../services/history_service.dart';

class HistoryController extends GetxController {
  final HistoryService _historyService = HistoryService();

  // Observable lists for scanned and saved (generated) codes
  var scannedHistory = <QrCodeRecord>[].obs;
  var generatedHistory = <QrCodeRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final allRecords = await _historyService.loadHistory();
    scannedHistory.value = allRecords.where((r) => r.type == 'scan').toList();
    generatedHistory.value = allRecords
        .where((r) => r.type == 'generate')
        .toList();

    // Sort latest first
    scannedHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    generatedHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<QrCodeRecord> addRecord(QrCodeRecord record) async {
    QrCodeRecord finalRecord;
    if (record.type == 'scan') {
      int index = scannedHistory.indexWhere((r) => r.data == record.data);
      if (index != -1) {
        var existing = scannedHistory[index];
        scannedHistory.removeAt(index);
        finalRecord = existing.copyWith(
          timestamp: record.timestamp,
          title: record.title ?? existing.title,
        );
        scannedHistory.insert(0, finalRecord);
      } else {
        scannedHistory.insert(0, record);
        finalRecord = record;
      }
    } else {
      int index = generatedHistory.indexWhere((r) => r.data == record.data);
      if (index != -1) {
        var existing = generatedHistory[index];
        generatedHistory.removeAt(index);
        finalRecord = existing.copyWith(
          timestamp: record.timestamp,
          title: record.title ?? existing.title,
        );
        generatedHistory.insert(0, finalRecord);
      } else {
        generatedHistory.insert(0, record);
        finalRecord = record;
      }
    }
    await _saveCurrentState();
    return finalRecord;
  }

  Future<void> updateRecord(QrCodeRecord updatedRecord) async {
    if (updatedRecord.type == 'scan') {
      int index = scannedHistory.indexWhere((r) => r.id == updatedRecord.id);
      if (index != -1) {
        scannedHistory[index] = updatedRecord;
      }
    } else {
      int index = generatedHistory.indexWhere((r) => r.id == updatedRecord.id);
      if (index != -1) {
        generatedHistory[index] = updatedRecord;
      }
    }
    await _saveCurrentState();
  }

  /// Export history as JSON
  ///
  Future<void> exportHistory() async {
    try {
      // Obtaining the actual JSON db file from the directory where it is saved
      final file = await _historyService.getHistoryFile();

      //Check if file actually exists and proceed
      if (!await file.exists()) {
        Get.snackbar(
          'Export Failed',
          'No history found to export.',
          snackPosition: SnackPosition.TOP,
        );
      }

      // Prepare param for saving
      final params = SaveFileDialogParams(
        sourceFilePath: file.path,
        fileName: 'chamo_qr_history.json',
      );

      // Save the file
      final saveFilePath = await FlutterFileDialog.saveFile(params: params);

      if (saveFilePath != null) {
        Get.snackbar(
          'Success',
          'History saved successfully.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export history: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Import history from JSON
  ///
  Future<void> importHistory() async {
    try {
      // Obtain the JSON file
      const params = OpenFileDialogParams(fileExtensionsFilter: ['json']);

      final filePath = await FlutterFileDialog.pickFile(params: params);

      if (filePath == null) return;

      // Read the JSON file
      final file = File(filePath);
      final String content = await file.readAsString();
      final List<dynamic> jsonContent = jsonDecode(content);

      // Convert raw JSON data to List<QrCodeRecord>
      final List<QrCodeRecord> importRecords = jsonContent
          .map((item) => QrCodeRecord.fromMap(item as Map<String, dynamic>))
          .toList();

      // Obtain the current records
      final currentRecords = [...scannedHistory, ...generatedHistory];
      final existingIDs = currentRecords.map((record) => record.id).toSet();

      // Obtain the records that are not exisitng currently but present in the backup file
      final List<QrCodeRecord> newRecords = importRecords
          .where((record) => !existingIDs.contains(record.id))
          .toList();

      // Show message if newRecords is empty
      if (newRecords.isEmpty) {
        Get.snackbar(
          'Import Complete',
          'No new entries were found to merge',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      // Merge newRecords to app records
      for (var record in newRecords) {
        if (record.type == 'scan') {
          scannedHistory.add(record);
        } else {
          generatedHistory.add(record);
        }
      }

      // Sort the list wrt Time
      scannedHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      generatedHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Save the final merged state to disk
      await _saveCurrentState();

      // Show success
      Get.snackbar(
        'Success',
        'Merged ${newRecords.length} new entries into your history.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // print(e);
    }
  }

  Future<void> clearHistory() async {
    scannedHistory.clear();
    generatedHistory.clear();
    await _historyService.clearHistory();
    await _saveCurrentState();

    Get.snackbar(
      'History Cleared',
      'Successfully cleared all entries from history',
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> _saveCurrentState() async {
    final allRecords = [...scannedHistory, ...generatedHistory];
    await _historyService.saveHistory(allRecords);
  }

  Future<void> deleteRecord(String id) async {
    scannedHistory.removeWhere((r) => r.id == id);
    generatedHistory.removeWhere((r) => r.id == id);
    await _historyService.deleteRecord(id);
    await _saveCurrentState();
  }
}
