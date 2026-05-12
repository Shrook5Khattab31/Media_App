class RecordingModel {
  final String path;
  final String fileName;
  final DateTime recordedAt;
  final Duration duration;
  final int fileSizeBytes;

  RecordingModel({
    required this.path,
    required this.fileName,
    required this.recordedAt,
    required this.duration,
    required this.fileSizeBytes,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get formattedDuration {
    final h = duration.inHours;
    final m = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(recordedAt);
    if (diff.inDays == 0) {
      final hour = recordedAt.hour > 12
          ? recordedAt.hour - 12
          : recordedAt.hour;
      final period = recordedAt.hour >= 12 ? 'PM' : 'AM';
      final min = recordedAt.minute.toString().padLeft(2, '0');
      return 'Today at $hour:$min $period';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${recordedAt.day}/${recordedAt.month}/${recordedAt.year}';
    }
  }

  String get shortDate {
    final now = DateTime.now();
    final diff = now.difference(recordedAt);
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays == 0) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${recordedAt.day}/${recordedAt.month}';
  }
}
