import 'package:nyetam/domain/place.dart';
import 'package:url_launcher/url_launcher.dart';

Uri googleMapsDirectionsUri(
  Place destination, {
  GeoPoint? origin,
  required bool walking,
}) {
  return Uri.https('www.google.com', '/maps/dir/', {
    'api': '1',
    if (origin != null) 'origin': '${origin.latitude},${origin.longitude}',
    'destination':
        '${destination.coordinates.latitude},${destination.coordinates.longitude}',
    'travelmode': walking ? 'walking' : 'driving',
  });
}

Future<bool> launchGoogleMapsDirections(
  Place destination, {
  GeoPoint? origin,
  required bool walking,
}) {
  return launchUrl(
    googleMapsDirectionsUri(destination, origin: origin, walking: walking),
    mode: LaunchMode.externalApplication,
  );
}
