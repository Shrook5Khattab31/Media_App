import 'package:flutter/material.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  static const Color _bg = Color(0xFF0A0A0F);
  static const Color _cyan = Color(0xFF00C2FF);
  static const Color _gray = Color(0xFF64748B);
  static const Color _cardBg = Color(0xFF1A1A28);
  static const Color _surface = Color(0xFF0E0E16);

  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Video', 'Audio'];

  final List<_MediaItem> _items = const [
    _MediaItem(
      name: 'Interview_01.mp4',
      size: '12.4 MB',
      time: '2h ago',
      duration: '03:42',
      imagePath: 'assets/images/interview.jpg',
      isAudio: false,
    ),
    _MediaItem(
      name: 'VoiceNote_Oct12.wav',
      size: '2.1 MB',
      time: '5h ago',
      isAudio: true,
      audioIcon: Icons.mic,
    ),
    _MediaItem(
      name: 'Surf_Session.mov',
      size: '45.8 MB',
      time: 'Yesterday',
      duration: '01:15',
      imagePath: 'assets/images/surf.jpg',
      isAudio: false,
    ),
    _MediaItem(
      name: 'Meeting_Recording.m...',
      size: '8.3 MB',
      time: 'Oct 10',
      isAudio: true,
      audioIcon: Icons.music_note,
    ),
    _MediaItem(
      name: 'Project_Demo_Final....',
      size: '112 MB',
      time: 'Oct 09',
      duration: '12:05',
      imagePath: 'assets/images/project.jpg',
      isAudio: false,
    ),
    _MediaItem(
      name: 'Podcast_S01E04.mp3',
      size: '42 MB',
      time: 'Oct 08',
      isAudio: true,
      audioIcon: Icons.podcasts,
    ),
  ];

  List<_MediaItem> get _filteredItems {
    if (_selectedTab == 0) return _items;
    if (_selectedTab == 1) return _items.where((e) => !e.isAudio).toList();
    return _items.where((e) => e.isAudio).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Library',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    children: [
                      // Filter button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1A1A28)),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Add button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: _cyan,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1A1A28)),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 14),
                    Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Search recordings...',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filter tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1A1A28)),
                ),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final isSelected = _selectedTab == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected ? _cardBg : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            border: isSelected
                                ? Border.all(color: _cyan.withOpacity(0.3))
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                color: isSelected ? _cyan : _gray,
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: _filteredItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    return _MediaCard(item: _filteredItems[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Media Card ──────────────────────────────────────────────────────────────

class _MediaCard extends StatelessWidget {
  final _MediaItem item;
  const _MediaCard({required this.item});

  static const Color _cardBg = Color(0xFF1A1A28);
  static const Color _cyan = Color(0xFF00C2FF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: item.isAudio
                    ? _AudioThumbnail(cardBg: _cardBg, cyan: _cyan)
                    : _VideoThumbnail(
                        imagePath: item.imagePath,
                        cardBg: _cardBg,
                      ),
              ),
              if (item.duration != null)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.duration!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              if (item.isAudio && item.audioIcon != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Icon(item.audioIcon, color: _cyan, size: 18),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${item.size} • ${item.time}',
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
        ),
      ],
    );
  }
}

// ── Audio Thumbnail ──────────────────────────────────────────────────────────

class _AudioThumbnail extends StatelessWidget {
  final Color cardBg;
  final Color cyan;
  const _AudioThumbnail({required this.cardBg, required this.cyan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: cardBg,
      child: CustomPaint(painter: _WaveformPainter(color: cyan)),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Color color;
  const _WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final heights = [0.3, 0.5, 0.7, 1.0, 0.8, 0.6, 0.9, 0.5, 0.7, 0.4, 0.6];
    final barWidth = size.width / (heights.length * 2.2);
    final centerY = size.height / 2;

    for (int i = 0; i < heights.length; i++) {
      final x = (size.width / 2) - ((heights.length / 2 - i) * barWidth * 2.2);
      final barHeight = heights[i] * size.height * 0.4;
      canvas.drawLine(
        Offset(x, centerY - barHeight),
        Offset(x, centerY + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Video Thumbnail ──────────────────────────────────────────────────────────

class _VideoThumbnail extends StatelessWidget {
  final String? imagePath;
  final Color cardBg;
  const _VideoThumbnail({this.imagePath, required this.cardBg});

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
    width: double.infinity,
    height: double.infinity,
    color: cardBg,
    child: const Icon(
      Icons.videocam_outlined,
      color: Color(0xFF3A3A5C),
      size: 36,
    ),
  );
}

// ── Data Model ───────────────────────────────────────────────────────────────

class _MediaItem {
  final String name;
  final String size;
  final String time;
  final String? duration;
  final String? imagePath;
  final bool isAudio;
  final IconData? audioIcon;

  const _MediaItem({
    required this.name,
    required this.size,
    required this.time,
    this.duration,
    this.imagePath,
    this.isAudio = false,
    this.audioIcon,
  });
}
