import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/domain/cameroon_region.dart';

void main() {
  test('every Cameroon region has destinations', () async {
    final places = await DemoPlaceRepository().getPlaces();

    for (final region in cameroonRegions) {
      final count = places.where((place) => place.region == region.name).length;
      final limit = region.name == 'Centre' || region.name == 'Littoral'
          ? 10
          : 5;

      expect(
        count,
        greaterThan(0),
        reason: '${region.name} should have destinations',
      );
      expect(
        count,
        lessThanOrEqualTo(limit),
        reason: '${region.name} exceeds its destination limit',
      );
    }
    expect(places.where((place) => place.region == 'Centre').length, 10);
    expect(cameroonRegions.length, 10);
  });
}
