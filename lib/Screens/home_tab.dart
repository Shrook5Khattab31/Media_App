import 'package:flutter/material.dart';
import '../Models/recording_model.dart';
import '../Store/recordings_store.dart';
import '../Utils/appColors.dart';
import 'capture_video_screen.dart';
import 'player_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 30),
              _sectionTitle('Start Recording'),
              const SizedBox(height: 14),
              _recordingButtons(context),
              const SizedBox(height: 30),
              _recentFilesHeader(),
              const SizedBox(height: 14),
              // Live recent list
              ListenableBuilder(
                listenable: RecordingsStore.instance,
                builder: (context, _) {
                  final recordings = RecordingsStore.instance.recent;
                  if (recordings.isEmpty) {
                    return _emptyRecent();
                  }
                  return Column(
                    children: recordings
                        .take(5)
                        .map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _recordingCard(context, r),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.darkCyanColor,
              child: const Icon(
                Icons.person,
                color: AppColors.cyanColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(color: AppColors.grayColor, fontSize: 13),
                ),
                const Text(
                  'User',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.secondBgColor,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.whiteColor,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _recordingButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionBtn(
            context,
            Icons.videocam_outlined,
            'Capture Video',
            active: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CaptureVideoScreen()),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _actionBtn(
            context,
            Icons.mic_outlined,
            'Record Audio',
            active: false,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(
    BuildContext context,
    IconData icon,
    String label, {
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 126,
        decoration: BoxDecoration(
          color: active ? AppColors.cyanColor : AppColors.secondBgColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: active
                    ? Colors.black.withOpacity(0.14)
                    : AppColors.darkCyanColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: active ? Colors.black : AppColors.cyanColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 11),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : AppColors.whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentFilesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle('Recent Files'),
        const Text(
          'See All',
          style: TextStyle(
            color: AppColors.cyanColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _emptyRecent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.videocam_off_outlined,
            color: AppColors.grayColor.withOpacity(0.4),
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'No recordings yet',
            style: TextStyle(color: AppColors.grayColor, fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap "Capture Video" to get started',
            style: TextStyle(color: AppColors.grayColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _recordingCard(BuildContext context, RecordingModel recording) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlayerScreen(recording: recording)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.secondBgColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            // Thumbnail placeholder
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.videocam_outlined,
                    color: AppColors.cyanColor,
                    size: 26,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        recording.formattedDuration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recording.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${recording.shortDate} • ${recording.formattedSize}',
                    style: const TextStyle(
                      color: AppColors.grayColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_vert, color: AppColors.grayColor),
          ],
        ),
      ),
    );
  }
}
