import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/services/location_service.dart';

class WelcomeFlow extends StatefulWidget {
  const WelcomeFlow({
    super.key,
    required this.locationService,
    required this.onComplete,
    this.onAuthenticate,
  });

  final LocationService locationService;
  final ValueChanged<GeoPoint?> onComplete;
  final Future<bool> Function()? onAuthenticate;

  @override
  State<WelcomeFlow> createState() => _WelcomeFlowState();
}

class _WelcomeFlowState extends State<WelcomeFlow> {
  final PageController _pageController = PageController();
  bool _isLocating = false;
  String? _locationMessage;
  LocationAccess? _locationAccess;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _requestLocation() async {
    setState(() {
      _isLocating = true;
      _locationMessage = null;
      _locationAccess = null;
    });
    final result = await widget.locationService.determinePosition();
    if (!mounted) return;

    if (result.access == LocationAccess.ready) {
      widget.onComplete(result.coordinates);
      return;
    }

    setState(() {
      _isLocating = false;
      _locationAccess = result.access;
      _locationMessage = switch (result.access) {
        LocationAccess.denied =>
          'Location access was declined. You can still browse Cameroon.',
        LocationAccess.deniedForever =>
          'Location is blocked. Enable it later in your device settings.',
        LocationAccess.servicesDisabled =>
          'Turn on location services to see accurate nearby places.',
        LocationAccess.ready => null,
      };
    });
  }

  Future<void> _openSettings() async {
    switch (_locationAccess) {
      case LocationAccess.servicesDisabled:
        await widget.locationService.openLocationSettings();
      case LocationAccess.deniedForever:
        await widget.locationService.openAppSettings();
      default:
        return;
    }
  }

  Future<void> _continueFromWelcome() async {
    final authenticated = await widget.onAuthenticate?.call() ?? true;
    if (!mounted || !authenticated) return;
    await _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _WelcomePage(onContinue: _continueFromWelcome),
          _LocationPage(
            isLocating: _isLocating,
            message: _locationMessage,
            locationAccess: _locationAccess,
            onAllow: _requestLocation,
            onOpenSettings: _openSettings,
            onSkip: () => widget.onComplete(null),
            onBack: () => _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?auto=format&fit=crop&w=1400&q=90',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(color: AppColors.forest),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x22000000), Color(0x44000000), Color(0xE611241B)],
              stops: [0, .45, 1],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.forest,
                      child: ClipOval(
                        child: Image.asset(
                          'images/mboa_nav_logo.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'MBOA NAV',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Cameroon,\ncloser than ever.',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 42,
                    height: 1.03,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Find remarkable places, trusted local experiences and the clearest route there.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.ink,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                    onPressed: onContinue,
                    child: const Text('Start exploring'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationPage extends StatelessWidget {
  const _LocationPage({
    required this.isLocating,
    required this.message,
    required this.locationAccess,
    required this.onAllow,
    required this.onOpenSettings,
    required this.onSkip,
    required this.onBack,
  });

  final bool isLocating;
  final String? message;
  final LocationAccess? locationAccess;
  final VoidCallback onAllow;
  final VoidCallback onOpenSettings;
  final VoidCallback onSkip;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: isLocating ? null : onBack,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    Center(
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3ECDD),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 116,
                              height: 116,
                              decoration: BoxDecoration(
                                color: AppColors.moss.withValues(alpha: .75),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Icon(
                              Icons.location_on,
                              size: 68,
                              color: AppColors.forest,
                            ),
                            const Positioned(
                              top: 30,
                              right: 25,
                              child: Icon(
                                Icons.restaurant,
                                color: AppColors.clay,
                              ),
                            ),
                            const Positioned(
                              bottom: 28,
                              left: 28,
                              child: Icon(
                                Icons.landscape,
                                color: AppColors.canopy,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'See what is around you',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mboa Nav uses your position to rank nearby places, calculate distance and show useful services in an emergency.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _PrivacyPoint(
                      icon: Icons.lock_outline,
                      text: 'Your precise location stays on your device.',
                    ),
                    const _PrivacyPoint(
                      icon: Icons.tune,
                      text: 'You remain in control of location access.',
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              message!,
                              style: const TextStyle(
                                color: AppColors.clay,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (locationAccess ==
                                  LocationAccess.servicesDisabled ||
                              locationAccess == LocationAccess.deniedForever)
                            IconButton(
                              tooltip:
                                  locationAccess ==
                                      LocationAccess.servicesDisabled
                                  ? 'Open location settings'
                                  : 'Open app settings',
                              onPressed: isLocating ? null : onOpenSettings,
                              icon: const Icon(Icons.settings_outlined),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isLocating ? null : onAllow,
                        icon: isLocating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(
                          isLocating
                              ? 'Finding your location'
                              : message == null
                              ? 'Allow location access'
                              : 'Check location again',
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: isLocating ? null : onSkip,
                        child: const Text('Browse without location'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  const _PrivacyPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: AppColors.forest, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
