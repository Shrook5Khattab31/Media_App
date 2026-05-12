import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/recording_model.dart';
import '../Store/recordings_store.dart';
import '../Utils/appColors.dart';
import 'media_extraction_hub.dart';

class CaptureVideoScreen extends StatefulWidget {
  const CaptureVideoScreen({super.key});

  @override
  State<CaptureVideoScreen> createState() => _CaptureVideoScreenState();
}

class _CaptureVideoScreenState extends State<CaptureVideoScreen>
    with SingleTickerProviderStateMixin {
  // ── Camera ──────────────────────────────────────────────────────────────────
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isPaused = false;
  int _selectedCameraIndex = 0;

  // ── Zoom ─────────────────────────────────────────────────────────────────────
  int _selectedZoom = 1;
  final List<double> _zoomLevels = [0.5, 1.0, 2.0];

  // ── Timer ───────────────────────────────────────────────────────────────────
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  final Stopwatch _stopwatch = Stopwatch();
  String _elapsed = '00 : 00 : 00';

  // ── Recording start time (for metadata) ─────────────────────────────────────
  DateTime? _recordingStartTime;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;
    await _setupCamera(_cameras[_selectedCameraIndex]);
  }

  Future<void> _setupCamera(CameraDescription description) async {
    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _cameraController = controller;
    try {
      await controller.initialize();
      await _applyZoom(_zoomLevels[_selectedZoom]);
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _applyZoom(double zoom) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    try {
      final minZoom = await _cameraController!.getMinZoomLevel();
      final maxZoom = await _cameraController!.getMaxZoomLevel();
      await _cameraController!.setZoomLevel(zoom.clamp(minZoom, maxZoom));
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isRecording) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    setState(() => _isCameraInitialized = false);
    await _cameraController?.dispose();
    await _setupCamera(_cameras[_selectedCameraIndex]);
  }

  // ── Recording ────────────────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    try {
      await _cameraController!.startVideoRecording();
      _recordingStartTime = DateTime.now();
      _stopwatch.reset();
      _stopwatch.start();
      _blinkController.repeat(reverse: true);
      _updateTimer();
      setState(() {
        _isRecording = true;
        _isPaused = false;
      });
    } catch (e) {
      debugPrint('Start recording error: $e');
    }
  }

  Future<void> _pauseResumeRecording() async {
    if (_cameraController == null || !_isRecording) return;
    try {
      if (_isPaused) {
        await _cameraController!.resumeVideoRecording();
        _stopwatch.start();
        _blinkController.repeat(reverse: true);
        setState(() => _isPaused = false);
      } else {
        await _cameraController!.pauseVideoRecording();
        _stopwatch.stop();
        _blinkController.stop();
        setState(() => _isPaused = true);
      }
    } catch (e) {
      debugPrint('Pause/resume error: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_cameraController == null || !_isRecording) return;
    try {
      final file = await _cameraController!.stopVideoRecording();
      final recordedDuration = _stopwatch.elapsed;
      final startTime = _recordingStartTime ?? DateTime.now();

      _stopwatch.stop();
      _blinkController.stop();

      setState(() {
        _isRecording = false;
        _isPaused = false;
        _elapsed = '00 : 00 : 00';
      });

      // ── Build metadata and save to store ──────────────────────────────────
      int fileSize = 0;
      try {
        fileSize = File(file.path).lengthSync();
      } catch (_) {}

      final recording = RecordingModel(
        path: file.path,
        fileName: file.path.split('/').last,
        recordedAt: startTime,
        duration: recordedDuration,
        fileSizeBytes: fileSize,
      );

      RecordingsStore.instance.addRecording(recording);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ExtractionHubScreen(videoPath: file.path, recording: recording),
          ),
        );
      }
    } catch (e) {
      debugPrint('Stop recording error: $e');
    }
  }

  void _updateTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_isRecording) return false;
      if (!_isPaused) {
        final s = _stopwatch.elapsed;
        final h = s.inHours.toString().padLeft(2, '0');
        final m = (s.inMinutes % 60).toString().padLeft(2, '0');
        final sec = (s.inSeconds % 60).toString().padLeft(2, '0');
        setState(() => _elapsed = '$h : $m : $sec');
      }
      return _isRecording;
    });
  }

  Future<void> _takeSnapshot() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    try {
      await _cameraController!.takePicture();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Snapshot saved!'),
            duration: Duration(seconds: 1),
            backgroundColor: AppColors.blueColor,
          ),
        );
      }
    } catch (e) {
      debugPrint('Snapshot error: $e');
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _blinkController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _cameraPreview(),
          Positioned(top: 52, left: 16, right: 16, child: _topBar()),
          Positioned(bottom: 0, left: 0, right: 0, child: _bottomControls()),
        ],
      ),
    );
  }

  Widget _cameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: const Color(0xFF0A0F1A),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.cyanColor),
        ),
      );
    }
    return CameraPreview(_cameraController!);
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          if (_isRecording) ...[
            FadeTransition(
              opacity: _blinkAnimation,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.redColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isPaused ? 'PAUSED' : 'REC',
              style: TextStyle(
                color: _isPaused ? Colors.orange : AppColors.redColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            _elapsed,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          if (!_isRecording)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.whiteColor,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottomControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 36, top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.85), Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _isRecording ? _pauseResumeRecording : null,
                child: _circleBtn(
                  _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  size: 52,
                  bg: _isRecording
                      ? AppColors.cardBg
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 24),
              _isRecording ? _stopBtn() : _recordBtn(),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: _isRecording ? _takeSnapshot : _switchCamera,
                child: _circleBtn(
                  _isRecording
                      ? Icons.camera_alt_outlined
                      : Icons.cameraswitch_outlined,
                  size: 52,
                  bg: AppColors.cardBg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _zoomSelector(),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 120,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, {required double size, required Color bg}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.whiteColor, size: size * 0.45),
    );
  }

  Widget _recordBtn() {
    return GestureDetector(
      onTap: _startRecording,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.redColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.redColor.withOpacity(0.45),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
        ),
        child: const Icon(
          Icons.videocam,
          color: AppColors.whiteColor,
          size: 32,
        ),
      ),
    );
  }

  Widget _stopBtn() {
    return GestureDetector(
      onTap: _stopRecording,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.redColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.redColor.withOpacity(0.45),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
        ),
        child: const Icon(
          Icons.stop_rounded,
          color: AppColors.whiteColor,
          size: 32,
        ),
      ),
    );
  }

  Widget _zoomSelector() {
    final zooms = ['0.5x', '1x', '2x'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(zooms.length, (i) {
        final isSelected = _selectedZoom == i;
        return GestureDetector(
          onTap: () async {
            setState(() => _selectedZoom = i);
            await _applyZoom(_zoomLevels[i]);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.blueColor
                  : Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.blueColor
                    : Colors.white.withOpacity(0.15),
              ),
            ),
            child: Text(
              zooms[i],
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }
}
