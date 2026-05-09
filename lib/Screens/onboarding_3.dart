import 'package:flutter/material.dart';

class OnboardingScreen_3 extends StatefulWidget {
  const OnboardingScreen_3({super.key});

  @override
  State<OnboardingScreen_3> createState() => _OnboardingScreen_3State();
}

class _OnboardingScreen_3State extends State<OnboardingScreen_3> {
  int _currentPage = 1; // 0-indexed, showing middle dot active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Onboarding',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF4FC3F7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hero image card
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image.asset(
                        'assets/images/header.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Page indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF4FC3F7)
                          : const Color(0xFF4FC3F7).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 28),

              // Title
              const Text(
                'Organize & Play',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Manage your recordings in custom playlists\nand enjoy seamless playback.',
                style: TextStyle(
                  color: Color(0xFF8A9BB0),
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // Feature cards row
              Row(
                children: [
                  // Playlist View card
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.folder_open_rounded,
                      iconColor: const Color(0xFF4FC3F7),
                      title: 'Playlist View',
                      subtitle: 'Custom folders',
                      backgroundWidget: _PlaylistThumbnail(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Media Player card
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.play_circle_fill_rounded,
                      iconColor: Colors.white,
                      title: 'Media Player',
                      subtitle: 'Seamless playback',
                      backgroundWidget: _MediaPlayerThumbnail(),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A8DFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Feature Card ────────────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget backgroundWidget;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.backgroundWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(height: 110, child: backgroundWidget),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF8A9BB0), fontSize: 12),
        ),
      ],
    );
  }
}

// ─── Playlist Thumbnail ───────────────────────────────────────────────────────

class _PlaylistThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A2535),
      child: Stack(
        children: [
          // Background items
          Positioned(
            left: 12,
            top: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniListItem(color: const Color(0xFF2A3A50)),
                const SizedBox(height: 6),
                _MiniListItem(color: const Color(0xFF2A3A50)),
                const SizedBox(height: 6),
                _MiniListItem(
                  color: const Color(0xFF2A3A50),
                  highlighted: true,
                ),
              ],
            ),
          ),
          // Folder icon overlay
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC3F7).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF4FC3F7).withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: Color(0xFF4FC3F7),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniListItem extends StatelessWidget {
  final Color color;
  final bool highlighted;

  const _MiniListItem({required this.color, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF4FC3F7).withOpacity(0.15) : color,
        borderRadius: BorderRadius.circular(6),
        border: highlighted
            ? Border.all(
                color: const Color(0xFF4FC3F7).withOpacity(0.3),
                width: 1,
              )
            : null,
      ),
    );
  }
}

// ─── Media Player Thumbnail ───────────────────────────────────────────────────

class _MediaPlayerThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A2535),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Waveform bars
          Positioned(
            left: 12,
            right: 12,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _WaveBar(height: 20),
                _WaveBar(height: 35),
                _WaveBar(height: 28),
                _WaveBar(height: 45),
                _WaveBar(height: 32),
                _WaveBar(height: 50, active: true),
                _WaveBar(height: 38),
                _WaveBar(height: 25),
                _WaveBar(height: 42),
                _WaveBar(height: 18),
                _WaveBar(height: 30),
                _WaveBar(height: 22),
              ],
            ),
          ),
          // Play button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.25),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Color(0xFF0F1923),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveBar extends StatelessWidget {
  final double height;
  final bool active;

  const _WaveBar({required this.height, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF4FC3F7)
            : const Color(0xFF4FC3F7).withOpacity(0.25),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ─── Wave Painter (Hero Image) ────────────────────────────────────────────────

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dark teal background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0D2436),
    );

    final waves = [
      // Bottom layer - darkest
      (offset: 0.85, color: const Color(0xFF0D3047), ctrl1: 0.25, ctrl2: 0.75),
      (offset: 0.72, color: const Color(0xFF0E4060), ctrl1: 0.3, ctrl2: 0.7),
      (offset: 0.60, color: const Color(0xFF0F5070), ctrl1: 0.2, ctrl2: 0.8),
      (offset: 0.47, color: const Color(0xFF116080), ctrl1: 0.35, ctrl2: 0.65),
      (offset: 0.35, color: const Color(0xFF137090), ctrl1: 0.25, ctrl2: 0.75),
      // Top layer - lightest
      (offset: 0.22, color: const Color(0xFF1590B0), ctrl1: 0.3, ctrl2: 0.7),
    ];

    for (final wave in waves) {
      final path = Path();
      final y = size.height * wave.offset;
      final amplitude = size.height * 0.07;

      path.moveTo(0, y);
      path.cubicTo(
        size.width * wave.ctrl1,
        y - amplitude,
        size.width * wave.ctrl2,
        y + amplitude,
        size.width,
        y,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, Paint()..color = wave.color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
