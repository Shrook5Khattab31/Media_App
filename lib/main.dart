import 'package:flutter/material.dart';
import 'Screens/dashboard.dart';
import 'Screens/media_extraction_hub.dart';
import 'Screens/splash_screen.dart';
import 'Screens/onBoarding_2.dart';
import 'Screens/onboarding.dart';
import 'Screens/onboarding_3.dart';
import 'Screens/player_screen.dart';
import 'Utils/routeNames.dart';

void main() {
  runApp(const MediaApp());
}

class MediaApp extends StatelessWidget {
  const MediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(),
      ),
      initialRoute: RouteNames.splashScreen,
      routes: {
        RouteNames.dashboard: (context) => const Dashboard(),
        RouteNames.splashScreen: (context) => const SplashScreen(),
        RouteNames.onboarding: (context) => const OnBoardingScreen(),
        RouteNames.onBoarding2: (context) => const OnboardingScreen2(),
        RouteNames.onBoarding3: (context) => const OnboardingScreen_3(),
        RouteNames.extractionHub: (context) => const ExtractionHubScreen(),
        RouteNames.playerScreen: (context) => const PlayerScreen(),
      },
    );
  }
}
