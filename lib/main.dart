import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/presentation/auth_controller.dart';
import 'package:nyetam/data/demo_culture_repository.dart';
import 'package:nyetam/data/demo_event_repository.dart';
import 'package:nyetam/data/demo_guide_repository.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/data/demo_review_repository.dart';
import 'package:nyetam/presentation/culture_controller.dart';
import 'package:nyetam/presentation/events_controller.dart';
import 'package:nyetam/presentation/explore_controller.dart';
import 'package:nyetam/presentation/guides_controller.dart';
import 'package:nyetam/presentation/reviews_controller.dart';
import 'package:nyetam/services/auth_service.dart';
import 'package:nyetam/services/google_identity_service.dart';
import 'package:nyetam/services/route_service.dart';

void main() {
  runApp(
    NyetamApp(
      authController: AuthController(
        service: ApiAuthService(baseUrl: _apiBaseUrl),
        googleIdentity: GoogleIdentityService(
          clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
          serverClientId: const String.fromEnvironment(
            'GOOGLE_SERVER_CLIENT_ID',
          ),
        ),
      ),
      controller: ExploreController(
        repository: DemoPlaceRepository(),
        routeService: ApiRouteService(baseUrl: _apiBaseUrl),
      ),
      cultureController: CultureController(repository: DemoCultureRepository()),
      eventsController: EventsController(repository: DemoEventRepository()),
      guidesController: GuidesController(repository: DemoGuideRepository()),
      reviewsController: ReviewsController(repository: DemoReviewRepository()),
    ),
  );
}

String get _apiBaseUrl {
  const configured = String.fromEnvironment('API_BASE_URL');
  if (configured.isNotEmpty) return configured;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://127.0.0.1:8000';
}
