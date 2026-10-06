import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/data/demo_auth_service.dart';
import 'package:nyetam/presentation/auth_controller.dart';
import 'package:nyetam/data/demo_culture_repository.dart';
import 'package:nyetam/data/demo_event_repository.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/data/demo_review_repository.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/presentation/culture_controller.dart';
import 'package:nyetam/presentation/explore_controller.dart';
import 'package:nyetam/presentation/events_controller.dart';
import 'package:nyetam/presentation/reviews_controller.dart';
import 'package:nyetam/presentation/welcome_flow.dart';
import 'package:nyetam/services/location_service.dart';

void main() {
  testWidgets('opens location settings and retries after GPS is enabled', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final locationService = _SettingsLocationService();
    GeoPoint? completedLocation;
    await tester.pumpWidget(
      MaterialApp(
        home: WelcomeFlow(
          locationService: locationService,
          onComplete: (location) => completedLocation = location,
        ),
      ),
    );

    await tester.tap(find.text('Start exploring'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow location access'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Open location settings'), findsOneWidget);
    await tester.tap(find.byTooltip('Open location settings'));
    expect(locationService.locationSettingsOpened, 1);

    await tester.tap(find.text('Check location again'));
    await tester.pump();

    expect(completedLocation, const GeoPoint(3.8480, 11.5021));
  });

  testWidgets('shows the Cameroon discovery experience', (tester) async {
    final controller = ExploreController(repository: DemoPlaceRepository());
    await tester.pumpWidget(
      NyetamApp(
        authController: AuthController(service: DemoAuthService()),
        controller: controller,
        cultureController: CultureController(
          repository: DemoCultureRepository(),
        ),
        eventsController: EventsController(repository: DemoEventRepository()),
        reviewsController: ReviewsController(
          repository: DemoReviewRepository(),
        ),
        locationService: const _SuccessfulLocationService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cameroon,\ncloser than ever.'), findsOneWidget);
    await tester.tap(find.text('Start exploring'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);

    final loginFields = find.byType(TextFormField);
    await tester.enterText(loginFields.at(0), 'traveler@nyetam.cm');
    await tester.enterText(loginFields.at(1), 'Cameroon123!');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('See what is around you'), findsOneWidget);

    await tester.tap(find.text('Allow location access'));
    await tester.pumpAndSettle();

    expect(find.text('MBOA NAV'), findsOneWidget);
    expect(find.text('Where will Cameroon\ntake you today?'), findsOneWidget);
    expect(find.text('Near you'), findsOneWidget);
    expect(find.text('3.8480° N, 11.5021° E'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Upcoming in Cameroon'), findsOneWidget);
    expect(find.text('Ngondo Festival'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View all 10'));
    await tester.pumpAndSettle();

    expect(find.text('Cameroon’s 10 regions'), findsOneWidget);
  });
}

class _SuccessfulLocationService implements LocationService {
  const _SuccessfulLocationService();

  @override
  Future<LocationResult> determinePosition() async {
    return const LocationResult(
      access: LocationAccess.ready,
      coordinates: GeoPoint(3.8480, 11.5021),
    );
  }

  @override
  Future<bool> openLocationSettings() async => true;

  @override
  Future<bool> openAppSettings() async => true;
}

class _SettingsLocationService implements LocationService {
  int _attempts = 0;
  int locationSettingsOpened = 0;

  @override
  Future<LocationResult> determinePosition() async {
    _attempts++;
    if (_attempts == 1) {
      return const LocationResult(access: LocationAccess.servicesDisabled);
    }
    return const LocationResult(
      access: LocationAccess.ready,
      coordinates: GeoPoint(3.8480, 11.5021),
    );
  }

  @override
  Future<bool> openLocationSettings() async {
    locationSettingsOpened++;
    return true;
  }

  @override
  Future<bool> openAppSettings() async => true;
}
