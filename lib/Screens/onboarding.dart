import 'package:flutter/material.dart';
import 'package:network/Utils/routeNames.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SF Pro Display'),
      home: const OnboardingCapturePage(),
    );
  }
}

class OnboardingCapturePage extends StatelessWidget {
  const OnboardingCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Skip button row
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushReplacementNamed(RouteNames.dashboard);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF29ABE2),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Hero illustration card
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2535),
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E2D40), Color(0xFF162030)],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/recording_illustration.png',
                    fit: BoxFit.contain, // or BoxFit.cover
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Title
              const Text(
                'All-in-One Recording',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'Capture everything from your\nscreen, camera, and audio in one\nplace.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFAAB4C2),
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 2),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PageDot(isActive: true),
                  const SizedBox(width: 8),
                  _PageDot(isActive: false),
                  const SizedBox(width: 8),
                  _PageDot(isActive: false),
                ],
              ),

              const Spacer(flex: 1),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29ABE2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
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

// Record icon inside the monitor
class _RecordIcon extends StatelessWidget {
  const _RecordIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3A8FB5), width: 3),
        ),
        child: Center(
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3A8FB5),
            ),
          ),
        ),
      ),
    );
  }
}

// Microphone illustration
class _MicrophoneIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mic capsule
        Container(
          width: 24,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFB0BEC5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF78909C), width: 1),
          ),
          child: const Center(
            child: Icon(Icons.mic, color: Color(0xFF455A64), size: 18),
          ),
        ),
        // Mic stand
        Container(width: 2, height: 16, color: const Color(0xFF3A8FB5)),
        // Base arc (simplified)
        Container(
          width: 36,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(color: const Color(0xFF3A8FB5), width: 2),
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        // Stand base
        Container(
          width: 48,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF1A5B78),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// App icon chip
class _AppIcon extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _AppIcon({
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}

// Page indicator dot
class _PageDot extends StatelessWidget {
  final bool isActive;
  const _PageDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF29ABE2) : const Color(0xFF3A4A5C),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
