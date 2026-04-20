import 'package:flutter/material.dart';
import 'capture_video_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  static const Color _bg = Color(0xFF0A0A0F);
  static const Color _card = Color(0xFF13131C);
  static const Color _cyan = Color(0xFF00C2FF);
  static const Color _cyanDark = Color(0xFF0F1C23);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _gray = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
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
              const SizedBox(height: 14),
              _storageBar(),
              const SizedBox(height: 30),
              _recentFilesHeader(),
              const SizedBox(height: 14),
              _videoCard(),
              const SizedBox(height: 12),
              _fileRow(
                leading: _waveIconBox(),
                title: 'Voice_Memo_004.wav',
                subtitle: _waveformRow(),
              ),
              const SizedBox(height: 12),
              _fileRow(
                leading: _thumbBox(Icons.code_outlined),
                title: 'Code_Review_Session.mp4',
                subtitle: Text(
                  'Yesterday • 18.2 MB',
                  style: TextStyle(color: _gray, fontSize: 12),
                ),
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
              backgroundColor: _cyanDark,
              child: const Icon(Icons.person, color: _cyan, size: 26),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,',
                    style: TextStyle(color: _gray, fontSize: 13)),
                const Text('Alex Rivera',
                    style: TextStyle(
                        color: _white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.notifications_outlined,
              color: _white, size: 22),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(
            color: _white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3));
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
              MaterialPageRoute(
                  builder: (_) => const CaptureVideoScreen()),
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
          color: active ? _cyan : _card,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: active ? Colors.black.withOpacity(0.14) : _cyanDark,
                borderRadius: BorderRadius.circular(15),
              ),
              child:
              Icon(icon, color: active ? Colors.black : _cyan, size: 28),
            ),
            const SizedBox(height: 11),
            Text(label,
                style: TextStyle(
                    color: active ? Colors.black : _white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _storageBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
          color: _card, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.cloud_upload_outlined, color: _cyan, size: 22),
          const SizedBox(width: 10),
          const Text('Storage: 4.2GB / 10GB',
              style: TextStyle(
                  color: _white, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.42,
                minHeight: 6,
                backgroundColor: _gray.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(_cyan),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentFilesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionTitle('Recent Files'),
        const Text('See All',
            style: TextStyle(
                color: _cyan, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _videoCard() {
    return Container(
      decoration: BoxDecoration(
          color: _card, borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 185,
                width: double.infinity,
                color: const Color(0xFF111E18),
                child: const Icon(Icons.landscape,
                    color: Color(0xFF1E3828), size: 90),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      shape: BoxShape.circle,
                    ),
                    child:
                    const Icon(Icons.play_arrow, color: _white, size: 30),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Text('04:12',
                      style: TextStyle(
                          color: _white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Interview_Tech_01.mp4',
                        style: TextStyle(
                            color: _white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Today • 10:24 AM • 24.8 MB',
                        style: TextStyle(color: _gray, fontSize: 12)),
                  ],
                ),
                Icon(Icons.more_vert, color: _gray),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileRow({
    required Widget leading,
    required String title,
    required Widget subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
          color: _card, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                subtitle,
              ],
            ),
          ),
          Icon(Icons.more_vert, color: _gray),
        ],
      ),
    );
  }

  Widget _waveIconBox() {
    final bars = [7.0, 13.0, 9.0, 17.0, 11.0, 15.0, 9.0, 7.0];
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
          color: _cyanDark, borderRadius: BorderRadius.circular(14)),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: bars
              .map((h) => Container(
            width: 3,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
                color: _cyan,
                borderRadius: BorderRadius.circular(2)),
          ))
              .toList(),
        ),
      ),
    );
  }

  Widget _waveformRow() {
    final bars = [5.0, 9.0, 12.0, 7.0, 14.0, 8.0, 5.0, 11.0, 7.0, 12.0];
    return Row(
      children: [
        ...bars.map((h) => Container(
          width: 3,
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
              color: _cyan, borderRadius: BorderRadius.circular(2)),
        )),
        const SizedBox(width: 8),
        Text('02:45', style: TextStyle(color: _gray, fontSize: 12)),
      ],
    );
  }

  Widget _thumbBox(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
          color: const Color(0xFF1A2030),
          borderRadius: BorderRadius.circular(14)),
      child: Icon(icon, color: _cyan, size: 24),
    );
  }
}