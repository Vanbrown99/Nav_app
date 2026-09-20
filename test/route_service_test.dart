import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/services/route_service.dart';

void main() {
  test('decodes a Google encoded polyline', () {
    final points = decodeGooglePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');

    expect(points.length, 3);
    expect(points.first.latitude, closeTo(38.5, .00001));
    expect(points.first.longitude, closeTo(-120.2, .00001));
    expect(points.last.latitude, closeTo(43.252, .00001));
    expect(points.last.longitude, closeTo(-126.453, .00001));
  });
}
