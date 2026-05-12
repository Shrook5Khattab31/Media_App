import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../Models/recording_model.dart';
import '../Utils/appColors.dart';

class PlayerScreen extends StatefulWidget {
  final RecordingModel? recording;

  const PlayerScreen({super.key, this.recording});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.recording == null) return;

    final file = File(widget.recording!.path);
    if (!file.existsSync()) return;

    final controller = VideoPlayerController.file(file);
    _controller = controller;

    await controller.initialize();
    controller.addListener(_onControllerUpdate);
    setState(() => _initialized = true);
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final playing = _controller?.value.isPlaying ?? false;
    if (playing != _isPlaying) {
      setState(() => _isPlaying = playing);
    }
    // Trigger rebuild for position updates
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$m:$s';
    }
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            if (_initialized && _controller != null) ...[
              Expanded(child: _videoArea()),
              _controls(),
            ] else ...[
              _placeholder(),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.recording?.fileName ?? 'Player',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _videoArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      clipBehavior: Clip.hardEdge,
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: GestureDetector(
          onTap: _togglePlay,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller!),
              if (!_isPlaying)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controls() {
    final position = _controller?.value.position ?? Duration.zero;
    final duration = _controller?.value.duration ?? Duration.zero;
    final maxSecs = duration.inSeconds.toDouble();
    final posSecs = position.inSeconds.toDouble().clamp(
      0,
      maxSecs > 0 ? maxSecs : 1,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Seek bar
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.cyanColor,
              inactiveTrackColor: AppColors.cardBg,
              thumbColor: AppColors.cyanColor,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 3,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: posSecs.toDouble(),
              max: maxSecs > 0 ? maxSecs : 1,
              onChanged: (v) =>
                  _controller?.seekTo(Duration(seconds: v.toInt())),
            ),
          ),

          // Time labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(position),
                  style: const TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  _format(duration),
                  style: const TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Playback buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _iconBtn(Icons.replay_10, () {
                final pos =
                    (_controller?.value.position ?? Duration.zero) -
                    const Duration(seconds: 10);
                _controller?.seekTo(pos < Duration.zero ? Duration.zero : pos);
              }),
              _playPauseBtn(),
              _iconBtn(Icons.forward_10, () {
                final pos =
                    (_controller?.value.position ?? Duration.zero) +
                    const Duration(seconds: 10);
                _controller?.seekTo(pos);
              }),
            ],
          ),

          // File info
          if (widget.recording != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.secondBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _infoChip(
                    Icons.timer_outlined,
                    widget.recording!.formattedDuration,
                  ),
                  _divider(),
                  _infoChip(
                    Icons.storage_outlined,
                    widget.recording!.formattedSize,
                  ),
                  _divider(),
                  _infoChip(
                    Icons.access_time_outlined,
                    widget.recording!.shortDate,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _playPauseBtn() {
    return GestureDetector(
      onTap: _togglePlay,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.cyanColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.cyanColor.withOpacity(0.35),
              blurRadius: 16,
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.black,
          size: 34,
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.cyanColor, size: 14),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 16, color: AppColors.borderColor);

  Widget _placeholder() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off_outlined,
              color: AppColors.grayColor.withOpacity(0.4),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Video not available',
              style: TextStyle(color: AppColors.grayColor, fontSize: 16),
            ),
            if (widget.recording != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.recording!.fileName,
                style: const TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _togglePlay() {
    if (_controller == null) return;
    setState(() {
      _isPlaying ? _controller!.pause() : _controller!.play();
    });
  }
}
