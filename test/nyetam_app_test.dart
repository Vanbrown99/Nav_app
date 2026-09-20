import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/data/demo_auth_service.dart';
import 'package:nyetam/presentation/auth_controller.dart';
import 'package:nyetam/data/demo_culture_repository.dart';
import 'package:nyetam/data/demo_event_repository.dart';
import 'package:nyetam/data/demo_guide_repository.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/data/demo_review_repository.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/presentation/culture_controller.dart';
import 'package:nyetam/presentation/explore_controller.dart';
import 'package:nyetam/presentation/events_controller.dart';
import 'package:nyetam/presentation/guides_controller.dart';
import 'package:nyetam/presentation/reviews_controller.dart';
import 'package:nyetam/services/location_service.dart';

void main() {
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
        guidesController: GuidesController(repository: DemoGuideRepository()),
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

    expect(find.text('NYETAM'), findsOneWidget);
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
}
