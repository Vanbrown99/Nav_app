import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/domain/cameroon_region.dart';

void main() {
  test('every Cameroon region has destinations', () async {
    final places = await DemoPlaceRepository().getPlaces();

    for (final region in cameroonRegions) {
      expect(
        places.where((place) => place.region == region.name),
        isNotEmpty,
        reason: '${region.name} should have at least one destination',
      );
    }
    expect(cameroonRegions.length, 10);
  });
}
