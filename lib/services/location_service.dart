import 'dart:math' as math;

import 'package:geolocator/geolocator.dart';
import 'package:nyetam/domain/place.dart';

enum LocationAccess { ready, denied, deniedForever, servicesDisabled }

class LocationResult {
  const LocationResult({required this.access, this.coordinates});

  final LocationAccess access;
  final GeoPoint? coordinates;
}

abstract interface class LocationService {
  Future<LocationResult> determinePosition();

  Future<bool> openLocationSettings();

  Future<bool> openAppSettings();
}

abstract interface class DistanceCalculator {
  double kilometersBetween(GeoPoint origin, GeoPoint destination);
}

class HaversineDistanceCalculator implements DistanceCalculator {
  const HaversineDistanceCalculator();

  @override
  double kilometersBetween(GeoPoint origin, GeoPoint destination) {
    const earthRadiusKm = 6371.0;
    final latitudeDelta = _radians(destination.latitude - origin.latitude);
    final longitudeDelta = _radians(destination.longitude - origin.longitude);
    final originLatitude = _radians(origin.latitude);
    final destinationLatitude = _radians(destination.latitude);
    final haversine =
        math.pow(math.sin(latitudeDelta / 2), 2) +
        math.cos(originLatitude) *
            math.cos(destinationLatitude) *
            math.pow(math.sin(longitudeDelta / 2), 2);
    return earthRadiusKm * 2 * math.asin(math.sqrt(haversine));
  }

  double _radians(double degrees) => degrees * math.pi / 180;
}

class DeviceLocationService implements LocationService {
  const DeviceLocationService();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<LocationResult> determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const LocationResult(access: LocationAccess.servicesDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return const LocationResult(access: LocationAccess.denied);
    }
    if (permission == LocationPermission.deniedForever) {
      return const LocationResult(access: LocationAccess.deniedForever);
    }

    final position = await Geolocator.getCurrentPosition();
    return LocationResult(
      access: LocationAccess.ready,
      coordinates: GeoPoint(position.latitude, position.longitude),
    );
  }
}
