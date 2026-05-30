import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/camera/presentation/screens/camera_screen.dart';

/// App Router Configuration
/// Defines all routes for MuseCam AI
class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String edit = '/edit';
  static const String gallery = '/gallery';
  static const String profile = '/profile';
  static const String premium = '/premium';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      routes: [
        // Splash Screen
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        // Onboarding Screen
        GoRoute(
          path: onboarding,
          name: 'onboarding',
          builder: (context, state) {
            // TODO: Import and add OnboardingScreen
            return const SizedBox();
          },
        ),
        // Home Screen
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) {
            // TODO: Import and add HomeScreen
            return const SizedBox();
          },
        ),
        // Camera Screen
        GoRoute(
          path: camera,
          name: 'camera',
          builder: (context, state) {
            return const CameraScreen();
          },
        ),
        // Edit Screen
        GoRoute(
          path: edit,
          name: 'edit',
          builder: (context, state) {
            // TODO: Import and add EditScreen
            return const SizedBox();
          },
        ),
        // Gallery Screen
        GoRoute(
          path: gallery,
          name: 'gallery',
          builder: (context, state) {
            // TODO: Import and add GalleryScreen
            return const SizedBox();
          },
        ),
        // Profile Screen
        GoRoute(
          path: profile,
          name: 'profile',
          builder: (context, state) {
            // TODO: Import and add ProfileScreen
            return const SizedBox();
          },
        ),
        // Premium Screen
        GoRoute(
          path: premium,
          name: 'premium',
          builder: (context, state) {
            // TODO: Import and add PremiumScreen
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
