import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/domain/place.dart';

void main() {
  test(
    'Yaounde catalog contains 50+ unique cross-category destinations',
    () async {
      final places = await DemoPlaceRepository().getPlaces();
      final yaounde = places.where((place) => place.city == 'Yaoundé').toList();

      expect(yaounde.length, greaterThanOrEqualTo(50));
      expect(yaounde.map((place) => place.id).toSet().length, yaounde.length);
      expect(
        yaounde.map((place) => place.category).toSet(),
        containsAll(PlaceCategory.values),
      );
      expect(
        yaounde.map((place) => place.name),
        containsAll([
          'National Museum',
          'Mvog-Betsi Zoo',
          'Reunification Monument',
          'Hilton Yaoundé',
          'Yaoundé General Hospital',
        ]),
      );
    },
  );
}
