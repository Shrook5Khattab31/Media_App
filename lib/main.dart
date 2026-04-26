import 'package:flutter/material.dart';
import 'package:network/Screens/dashboard.dart';
import 'package:network/Screens/splash_screen.dart';
import 'Screens/onBoarding_2.dart';
import 'package:network/Screens/onboarding.dart';
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
        RouteNames.onBoarding2:(context)=>OnboardingScreen2(),
      },
    );
  }
}