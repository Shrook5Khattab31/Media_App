import 'package:flutter/material.dart';
import 'Screens/dashboard.dart';
import 'Screens/media_extraction_hub.dart';
import 'Screens/splash_screen.dart';
import 'Screens/onBoarding_2.dart';
import 'Screens/onboarding.dart';
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
      initialRoute: RouteNames.splashScreen,
      routes: {
        RouteNames.dashboard: (context) => Dashboard(),
        RouteNames.splashScreen: (context) => SplashScreen(),
        RouteNames.onboarding: (context) => OnBoardingScreen(),
        RouteNames.onBoarding2: (context) =>OnboardingScreen2(),
        RouteNames.extractionHub: (context) =>ExtractionHubScreen(),
      },
    );
  }
}