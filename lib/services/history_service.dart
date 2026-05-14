import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/qr_code_model.dart';

class HistoryService {
  // JSON file name
  static const String _fileName = 'qr_history.json';

  /// Get the directory path, platform dependent
  /// On android it returns the path to the app's documents directory
  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  /// Returns the actual history file object
  Future<File> getHistoryFile() async {
    return _file;
  }

  /// Load history from JSON file
  Future<List<QrCodeRecord>> loadHistory() async {
    try {
      final file = await _file;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      if (contents.isEmpty) return [];

      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => QrCodeRecord.fromMap(json)).toList();
    } catch (e) {
      // print('Error loading history: $e');
      return [];
    }
  }

  /// Save history to JSON file
  Future<void> saveHistory(List<QrCodeRecord> history) async {
    try {
      final file = await _file;
      final jsonList = history.map((record) => record.toMap()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      // print('Error saving history: $e');
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      final file = await _file;
      await file.writeAsString('[]');
    } catch (e) {
      // print('Error clearing history: $e');
    }
  }

  /// Delete a record from history
  Future<void> deleteRecord(String id) async {
    try {
      final history = await loadHistory();
      history.removeWhere((record) => record.id == id);
      await saveHistory(history);
    } catch (e) {
      // print('Error deleting record: $e');
    }
  }
}
