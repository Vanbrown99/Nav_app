import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nyetam/domain/place.dart';

class RoutePlan {
  const RoutePlan({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
  });

  final List<GeoPoint> points;
  final double distanceKm;
  final int durationMinutes;
}

abstract interface class RouteService {
  Future<RoutePlan> computeRoute(List<GeoPoint> waypoints);
}

class ApiRouteService implements RouteService {
  ApiRouteService({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  @override
  Future<RoutePlan> computeRoute(List<GeoPoint> waypoints) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/v1/routes/compute'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'waypoints': waypoints
            .map(
              (point) => {
                'latitude': point.latitude,
                'longitude': point.longitude,
              },
            )
            .toList(),
      }),
    );
    if (response.statusCode != 200) {
      throw StateError('Route provider unavailable');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return RoutePlan(
      points: decodeGooglePolyline(body['encoded_polyline'] as String),
      distanceKm: (body['distance_meters'] as num) / 1000,
      durationMinutes: ((body['duration_seconds'] as num) / 60).round(),
    );
  }
}

List<GeoPoint> decodeGooglePolyline(String encoded) {
  final points = <GeoPoint>[];
  var index = 0;
  var latitude = 0;
  var longitude = 0;

  int decodeValue() {
    var result = 0;
    var shift = 0;
    int byte;
    do {
      byte = encoded.codeUnitAt(index++) - 63;
      result |= (byte & 0x1f) << shift;
      shift += 5;
    } while (byte >= 0x20 && index < encoded.length);
    return (result & 1) != 0 ? ~(result >> 1) : result >> 1;
  }

  while (index < encoded.length) {
    latitude += decodeValue();
    longitude += decodeValue();
    points.add(GeoPoint(latitude / 1e5, longitude / 1e5));
  }
  return points;
}
