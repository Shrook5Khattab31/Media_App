import 'dart:io';
import 'package:flutter/material.dart';
import '../Models/recording_model.dart';
import '../Utils/appColors.dart';

class ExtractionHubScreen extends StatefulWidget {
  final String? videoPath;
  final RecordingModel? recording;

  const ExtractionHubScreen({super.key, this.videoPath, this.recording});

  @override
  State<ExtractionHubScreen> createState() => _ExtractionHubScreenState();
}

class _ExtractionHubScreenState extends State<ExtractionHubScreen>
    with SingleTickerProviderStateMixin {
  int _videoTab = 0;
  late final AnimationController _pulse;

  // ── Derived metadata ──────────────────────────────────────────────────────
  String get _fileName {
    if (widget.recording != null) return widget.recording!.fileName;
    if (widget.videoPath == null || widget.videoPath!.isEmpty)
      return 'Recording_001';
    return widget.videoPath!.split('/').last;
  }

  String get _fileSize {
    if (widget.recording != null) return widget.recording!.formattedSize;
    if (widget.videoPath == null) return '— MB';
    try {
      final bytes = File(widget.videoPath!).lengthSync();
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (_) {
      return '— MB';
    }
  }

  String get _recordedAt {
    if (widget.recording != null) return widget.recording!.formattedDate;
    if (widget.videoPath == null) return 'Just now';
    try {
      final modified = File(widget.videoPath!).lastModifiedSync();
      final hour = modified.hour > 12 ? modified.hour - 12 : modified.hour;
      final period = modified.hour >= 12 ? 'PM' : 'AM';
      final min = modified.minute.toString().padLeft(2, '0');
      return 'Today at $hour:$min $period';
    } catch (_) {
      return 'Just now';
    }
  }

  String get _duration {
    if (widget.recording != null) return widget.recording!.formattedDuration;
    return '--:--';
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _onSave,
              icon: const Icon(
                Icons.save_alt_rounded,
                size: 20,
                color: Colors.white,
              ),
              label: const Text(
                'Save to Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryCard(),
                    const SizedBox(height: 20),
                    _label('Export Video'),
                    const SizedBox(height: 10),
                    _videoCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    // Recording was already added to the store when recording stopped.
    // Just pop back to dashboard so user sees it in Library/Recent.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to Library!'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.blueColor,
      ),
    );
    // Pop back to the root (Dashboard)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _topBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const Expanded(
          child: Text(
            'Extraction Hub',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
          child: const Text(
            'Discard',
            style: TextStyle(
              color: Color(0xFFE05050),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _summaryCard() => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF111827),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.darkBorder),
    ),
    clipBehavior: Clip.hardEdge,
    child: Column(
      children: [
        Container(
          height: 175,
          color: const Color(0xFF0A121E),
          child: Center(child: _phoneMockup()),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _fileName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.grayColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _recordedAt,
                      style: const TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      '$_fileSize • $_duration',
                      style: const TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueColor,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _phoneMockup() => Container(
    width: 132,
    height: 155,
    decoration: BoxDecoration(
      color: const Color(0xFF182030),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF243040), width: 2),
    ),
    clipBehavior: Clip.hardEdge,
    child: Column(
      children: [
        Container(
          height: 20,
          color: const Color(0xFF141E2E),
          alignment: Alignment.center,
          child: const Text(
            'Recording',
            style: TextStyle(color: Color(0xFF3A4A58), fontSize: 8),
          ),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFF0A1520),
            child: Center(
              child: Icon(
                Icons.videocam,
                color: AppColors.cyanColor.withOpacity(0.4),
                size: 40,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _label(String t) => Text(
    t,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _videoCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF111827),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.darkBorder),
    ),
    child: Column(
      children: [
        _tabs(
          ['MP4 (H.264)', 'MKV'],
          _videoTab,
          (i) => setState(() => _videoTab = i),
        ),
        const SizedBox(height: 14),
        _progressRow('Ready to Export', 0.0, AppColors.cyanColor),
        const SizedBox(height: 14),
        _btn(
          Icons.video_file_outlined,
          'Export High Quality',
          const Color(0xFF182030),
          Colors.white70,
        ),
      ],
    ),
  );

  Widget _tabs(
    List<String> labels,
    int sel,
    ValueChanged<int> onTap,
  ) => Container(
    height: 44,
    decoration: BoxDecoration(
      color: const Color(0xFF0D1520),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: List.generate(labels.length, (i) {
        final active = i == sel;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? const Color(0xFF1A2640) : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
                border: active
                    ? Border.all(color: AppColors.blueColor.withOpacity(0.35))
                    : null,
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  color: active ? Colors.white : AppColors.grayColor,
                  fontSize: 13.5,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );

  Widget _progressRow(String label, double val, Color color) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.grayColor, fontSize: 12.5),
          ),
          Text(
            '${(val * 100).toInt()}%',
            style: TextStyle(
              color: val > 0 ? Colors.white : AppColors.grayColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 7),
      ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: LinearProgressIndicator(
          value: val,
          minHeight: 5,
          backgroundColor: const Color(0xFF182030),
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    ],
  );

  Widget _btn(IconData icon, String label, Color bg, Color textColor) =>
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(icon, size: 18, color: textColor),
          label: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
              side: BorderSide(color: AppColors.darkBorder),
            ),
          ),
        ),
      );
}
