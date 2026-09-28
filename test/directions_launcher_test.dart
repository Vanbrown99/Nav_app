import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/services/directions_launcher.dart';

void main() {
  const destination = Place(
    id: 'mount-cameroon',
    name: 'Mount Cameroon',
    city: 'Buea',
    region: 'South-West',
    category: PlaceCategory.attraction,
    description: 'A volcanic mountain.',
    imageUrl: '',
    coordinates: GeoPoint(4.2038, 9.1706),
    rating: 4.8,
    reviewCount: 10,
    distanceKm: 12,
    travelMinutes: 30,
    openingHours: 'Daily',
    priceLabel: 'Varies',
    tags: [],
  );

  test('builds Google Maps walking directions with the current location', () {
    final uri = googleMapsDirectionsUri(
      destination,
      origin: const GeoPoint(3.8667, 11.5167),
      walking: true,
    );

    expect(uri.host, 'www.google.com');
    expect(uri.path, '/maps/dir/');
    expect(uri.queryParameters['api'], '1');
    expect(uri.queryParameters['origin'], '3.8667,11.5167');
    expect(uri.queryParameters['destination'], '4.2038,9.1706');
    expect(uri.queryParameters['travelmode'], 'walking');
  });

  test(
    'builds driving directions without an origin when location is unknown',
    () {
      final uri = googleMapsDirectionsUri(destination, walking: false);

      expect(uri.queryParameters.containsKey('origin'), isFalse);
      expect(uri.queryParameters['travelmode'], 'driving');
    },
  );
}
