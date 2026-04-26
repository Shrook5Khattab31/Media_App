import 'package:flutter/material.dart';
import 'package:network/Screens/dashboard.dart';
import 'package:network/Screens/splash_screen.dart';
import 'Screens/onBoarding_2.dart';
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
        RouteNames.dashboard:(context)=>Dashboard(),
        RouteNames.splashScreen:(context)=>SplashScreen(),
        RouteNames.onBoarding2:(context)=>OnboardingScreen(),
      },
    );
  }
}