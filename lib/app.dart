import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyetam/presentation/auth_controller.dart';
import 'package:nyetam/presentation/auth_page.dart';
import 'package:nyetam/presentation/culture_controller.dart';
import 'package:nyetam/presentation/events_controller.dart';
import 'package:nyetam/presentation/explore_controller.dart';
import 'package:nyetam/presentation/home_shell.dart';
import 'package:nyetam/presentation/reviews_controller.dart';
import 'package:nyetam/presentation/reviews_scope.dart';
import 'package:nyetam/presentation/welcome_flow.dart';
import 'package:nyetam/services/location_service.dart';

class AppColors {
  static const forest = Color(0xFF0B5D3B);
  static const canopy = Color(0xFF217A4B);
  static const moss = Color(0xFFB7C9A8);
  static const gold = Color(0xFFD5A62D);
  static const clay = Color(0xFFC76D40);
  static const cream = Color(0xFFF7F5ED);
  static const ink = Color(0xFF173129);
  static const muted = Color(0xFF62736B);
}

class NyetamApp extends StatelessWidget {
  const NyetamApp({
    super.key,
    required this.authController,
    required this.controller,
    required this.cultureController,
    required this.eventsController,
    required this.reviewsController,
    this.locationService = const DeviceLocationService(),
  });

  final AuthController authController;
  final ExploreController controller;
  final CultureController cultureController;
  final EventsController eventsController;
  final ReviewsController reviewsController;
  final LocationService locationService;

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.dmSansTextTheme().copyWith(
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nyetam Cameroon',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.forest,
          primary: AppColors.forest,
          secondary: AppColors.gold,
          surface: AppColors.cream,
        ),
        scaffoldBackgroundColor: AppColors.cream,
        textTheme: textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.ink,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: AppColors.muted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: _LaunchFlow(
        authController: authController,
        controller: controller,
        cultureController: cultureController,
        eventsController: eventsController,
        reviewsController: reviewsController,
        locationService: locationService,
      ),
    );
  }
}

class _LaunchFlow extends StatefulWidget {
  const _LaunchFlow({
    required this.authController,
    required this.controller,
    required this.cultureController,
    required this.eventsController,
    required this.reviewsController,
    required this.locationService,
  });

  final AuthController authController;
  final ExploreController controller;
  final CultureController cultureController;
  final EventsController eventsController;
  final ReviewsController reviewsController;
  final LocationService locationService;

  @override
  State<_LaunchFlow> createState() => _LaunchFlowState();
}

class _LaunchFlowState extends State<_LaunchFlow> {
  bool _isReady = false;

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return ReviewsScope(
        controller: widget.reviewsController,
        child: HomeShell(
          controller: widget.controller,
          cultureController: widget.cultureController,
          eventsController: widget.eventsController,
        ),
      );
    }

    return WelcomeFlow(
      locationService: widget.locationService,
      onAuthenticate: () async {
        if (widget.authController.status == AuthStatus.authenticated) {
          return true;
        }
        return await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => AuthPage(controller: widget.authController),
              ),
            ) ??
            false;
      },
      onComplete: (coordinates) {
        widget.controller.setCurrentLocation(coordinates);
        setState(() => _isReady = true);
      },
    );
  }
}
