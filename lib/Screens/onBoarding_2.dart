import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:network/Utils/routeNames.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70, size: 18),
                      onPressed: () {},
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, RouteNames.dashboard);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF29C6F7),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Animated illustration card
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 0.5),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF161D27),
                        Color(0xFF0F151E),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.06),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF29C6F7).withOpacity(0.08),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Waveform background
                        AnimatedBuilder(
                          animation: _waveController,
                          builder: (context, _) {
                            return CustomPaint(
                              size: const Size(double.infinity, 220),
                              painter: WaveformPainter(
                                progress: _waveController.value,
                                pulseValue: _pulseController.value,
                              ),
                            );
                          },
                        ),

                        // Center icon card
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.04),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 80,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF1E3A4A),
                                  Color(0xFF132530),
                                ],
                              ),
                              border: Border.all(
                                color:
                                const Color(0xFF29C6F7).withOpacity(0.4),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF29C6F7)
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.movie_filter_outlined,
                                    color: Color(0xFF29C6F7), size: 20),
                                const Icon(Icons.arrow_forward,
                                    color: Color(0xFF29C6F7), size: 16),
                                const Icon(Icons.audio_file_outlined,
                                    color: Color(0xFF29C6F7), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Text content
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    const Text(
                      'Precision Extraction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Extract audio and video streams with\nprofessional-grade quality settings.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 14.5,
                        height: 1.55,
                        letterSpacing: 0.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Page indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(false),
                  const SizedBox(width: 6),
                  _buildDot(true),
                  const SizedBox(width: 6),
                  _buildDot(false),
                ],
              ),

              const SizedBox(height: 28),

              // Continue button
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1BC8F5), Color(0xFF0DA8D8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF29C6F7).withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () { //Todo: onboarding3
                        Navigator.pushReplacementNamed(context, RouteNames.dashboard);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward,
                              color: Colors.white, size: 18),
                        ],
                      ),
                    ),
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

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF29C6F7)
            : Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  final double pulseValue;

  WaveformPainter({required this.progress, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final random = math.Random(42);

    // Draw waveform bars
    const barCount = 55;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;

      // Create varied heights
      final baseHeight = random.nextDouble() * 0.55 + 0.08;
      final wave = math.sin((i / barCount * 2 * math.pi) +
          (progress * 2 * math.pi)) *
          0.25;
      final pulse = math.sin(progress * 2 * math.pi + i * 0.15) * 0.12;

      final barHeight = (baseHeight + wave + pulse).clamp(0.05, 0.9);
      final halfHeight = (centerY * barHeight);

      // Distance from center for color gradient
      final distFromCenter = (x - size.width / 2).abs() / (size.width / 2);
      final opacity = (1 - distFromCenter * 0.7).clamp(0.15, 1.0);

      // Active area highlight
      final isActive = (i / barCount - progress).abs() < 0.15 ||
          ((i / barCount - progress) + 1).abs() < 0.15;

      final paint = Paint()
        ..color = isActive
            ? const Color(0xFF29C6F7).withOpacity(opacity * 0.9)
            : const Color(0xFF29C6F7).withOpacity(opacity * 0.25)
        ..strokeWidth = barWidth * 0.55
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, centerY - halfHeight),
        Offset(x, centerY + halfHeight),
        paint,
      );
    }

    // Subtle center glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF29C6F7).withOpacity(0.12 + pulseValue * 0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCenter(
        center: Offset(size.width / 2, centerY),
        width: size.width * 0.6,
        height: size.height * 0.6,
      ));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pulseValue != pulseValue;
}