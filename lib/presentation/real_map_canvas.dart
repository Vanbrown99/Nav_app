import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/place.dart';

class RealMapCanvas extends StatelessWidget {
  const RealMapCanvas({
    super.key,
    required this.mapController,
    required this.places,
    required this.itinerary,
    required this.routePoints,
    required this.currentLocation,
    required this.selectedPlace,
    required this.directionDestination,
    required this.onPlaceSelected,
  });

  final MapController mapController;
  final List<Place> places;
  final List<Place> itinerary;
  final List<GeoPoint> routePoints;
  final GeoPoint? currentLocation;
  final Place? selectedPlace;
  final Place? directionDestination;
  final ValueChanged<Place> onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    final tripPoints =
        (routePoints.isNotEmpty
                ? routePoints
                : itinerary.map((place) => place.coordinates))
            .map(_latLng)
            .toList(growable: false);

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: const MapOptions(
            initialCenter: LatLng(5.2, 11.7),
            initialZoom: 5.4,
            minZoom: 4,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'cm.nyetam.nyetam',
              maxNativeZoom: 19,
            ),
            if (tripPoints.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: tripPoints,
                    color: AppColors.clay,
                    strokeWidth: 5,
                  ),
                ],
              ),
            if (currentLocation != null && directionDestination != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [
                      _latLng(currentLocation!),
                      _latLng(directionDestination!.coordinates),
                    ],
                    color: AppColors.gold,
                    strokeWidth: 5,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                for (final place in places.take(80))
                  Marker(
                    point: _latLng(place.coordinates),
                    width: 44,
                    height: 48,
                    child: _PlaceMarker(
                      place: place,
                      selected: place.id == selectedPlace?.id,
                      itineraryIndex: itinerary.indexWhere(
                        (stop) => stop.id == place.id,
                      ),
                      onTap: () => onPlaceSelected(place),
                    ),
                  ),
                if (currentLocation case final location?)
                  Marker(
                    point: _latLng(location),
                    width: 24,
                    height: 24,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF2878E5),
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 3),
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 5),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        const Positioned(
          right: 8,
          bottom: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Text(
                '© OpenStreetMap contributors',
                style: TextStyle(fontSize: 10, color: Color(0xFF333333)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static LatLng _latLng(GeoPoint point) =>
      LatLng(point.latitude, point.longitude);
}

class _PlaceMarker extends StatelessWidget {
  const _PlaceMarker({
    required this.place,
    required this.selected,
    required this.itineraryIndex,
    required this.onTap,
  });

  final Place place;
  final bool selected;
  final int itineraryIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inTrip = itineraryIndex >= 0;
    return Semantics(
      button: true,
      label: place.name,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: selected ? 42 : 36,
          height: selected ? 42 : 36,
          decoration: BoxDecoration(
            color: inTrip
                ? AppColors.clay
                : selected
                ? AppColors.gold
                : AppColors.forest,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: inTrip
                ? Text(
                    '${itineraryIndex + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                : Icon(place.category.icon, color: Colors.white, size: 17),
          ),
        ),
      ),
    );
  }
}
