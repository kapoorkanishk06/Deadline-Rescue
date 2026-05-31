import 'screens/screens.dart';
import 'package:project_1/screens/processing_screen.dart';
import 'package:project_1/screens/rescue_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// GoRouter configuration for app navigation
///
/// This uses go_router for declarative routing, which provides:
/// - Type-safe navigation
/// - Deep linking support (web URLs, app links)
/// - Easy route parameters
/// - Navigation guards and redirects
///
/// To add a new route:
/// 1. Add a route constant to AppRoutes below
/// 2. Add a GoRoute to the routes list
/// 3. Navigate using context.go() or context.push()
/// 4. Use context.pop() to go back.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'context',
        pageBuilder: (context, state) => _fadeSlide(const ContextSetupScreen()),
      ),
      GoRoute(
        path: AppRoutes.dump,
        name: 'dump',
        pageBuilder: (context, state) => _fadeSlide(const BrainDumpScreen()),
      ),
      GoRoute(
        path: AppRoutes.processing,
        name: 'processing',
        pageBuilder: (context, state) => _fadeSlide(const ProcessingScreen()),
      ),
      GoRoute(
        path: AppRoutes.results,
        name: 'results',
        pageBuilder: (context, state) => _fadeSlide(const RescueResultsScreen()),
      ),
    ],
  );

  static CustomTransitionPage _fadeSlide(Widget child) => CustomTransitionPage(
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offset = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(animation);
          final opacity = Tween<double>(begin: 0, end: 1).animate(animation);
          return FadeTransition(opacity: opacity, child: SlideTransition(position: offset, child: child));
        },
        transitionDuration: const Duration(milliseconds: 220),
      );
}

/// Route path constants
/// Use these instead of hard-coding route strings
class AppRoutes {
  static const String home = '/';
  static const String dump = '/dump';
  static const String processing = '/processing';
  static const String results = '/results';
}
