import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/presentation/explore_controller.dart';

void main() {
  test('calculates and reorders an itinerary route', () async {
    final controller = ExploreController(repository: DemoPlaceRepository());
    await controller.load();
    final first = controller.places.first;
    final second = controller.places[1];

    controller.toggleTripPlace(first);
    controller.toggleTripPlace(second);

    expect(controller.tripDistanceKm, greaterThan(0));
    expect(controller.tripEstimatedMinutes, greaterThan(0));

    controller.moveTripPlace(1, -1);
    expect(controller.tripPlaces.first.id, second.id);
  });
}
