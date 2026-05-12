import 'package:flutter/foundation.dart';
import '../Models/recording_model.dart';

/// Singleton in-memory store for all recordings.
/// Uses ChangeNotifier so any widget can listen for updates.
class RecordingsStore extends ChangeNotifier {
  RecordingsStore._();
  static final RecordingsStore instance = RecordingsStore._();

  final List<RecordingModel> _recordings = [];

  List<RecordingModel> get recordings => List.unmodifiable(_recordings);

  /// Most recent first
  List<RecordingModel> get recent {
    final sorted = [..._recordings];
    sorted.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return sorted;
  }

  void addRecording(RecordingModel recording) {
    _recordings.insert(0, recording);
    notifyListeners();
  }

  void removeRecording(RecordingModel recording) {
    _recordings.remove(recording);
    notifyListeners();
  }
}
