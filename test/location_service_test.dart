import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/services/location_service.dart';

void main() {
  test('calculates distance between Yaounde and Douala', () {
    const calculator = HaversineDistanceCalculator();

    final distance = calculator.kilometersBetween(
      const GeoPoint(3.8480, 11.5021),
      const GeoPoint(4.0511, 9.7679),
    );

    expect(distance, closeTo(193, 5));
  });
}
