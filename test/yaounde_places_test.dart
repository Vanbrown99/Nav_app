import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/domain/place.dart';

void main() {
  test('Centre catalog contains 10 unique destinations', () async {
    final places = await DemoPlaceRepository().getPlaces();
    final centre = places.where((place) => place.region == 'Centre').toList();

    expect(centre, hasLength(10));
    expect(centre.map((place) => place.id).toSet().length, centre.length);
    expect(
      centre.map((place) => place.category).toSet(),
      contains(PlaceCategory.attraction),
    );
    expect(centre.map((place) => place.name), contains('National Museum'));
  });
}
