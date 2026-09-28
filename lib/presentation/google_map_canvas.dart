import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/place.dart';

const googleMapsConfigured = bool.fromEnvironment(
  'GOOGLE_MAPS_CONFIGURED',
  defaultValue: false,
);

bool get googleMapsSupportedPlatform =>
    kIsWeb ||
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

class GoogleTourismMap extends StatefulWidget {
  const GoogleTourismMap({
    super.key,
    required this.places,
    required this.itinerary,
    required this.routePoints,
    required this.currentLocation,
    required this.selectedPlace,
    required this.directionDestination,
    required this.onPlaceSelected,
    required this.onControllerReady,
  });

  final List<Place> places;
  final List<Place> itinerary;
  final List<GeoPoint> routePoints;
  final GeoPoint? currentLocation;
  final Place? selectedPlace;
  final Place? directionDestination;
  final ValueChanged<Place> onPlaceSelected;
  final ValueChanged<GoogleMapController> onControllerReady;

  @override
  State<GoogleTourismMap> createState() => _GoogleTourismMapState();
}

class _GoogleTourismMapState extends State<GoogleTourismMap> {
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(covariant GoogleTourismMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selected = widget.selectedPlace;
    if (selected != null && selected.id != oldWidget.selectedPlace?.id) {
      unawaited(
        _controller?.animateCamera(
          CameraUpdate.newLatLngZoom(_latLng(selected.coordinates), 14),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routePoints =
        (widget.routePoints.isNotEmpty
                ? widget.routePoints
                : widget.itinerary.map((place) => place.coordinates))
            .map(_latLng)
            .toList(growable: false);
    final directionPoints =
        widget.currentLocation == null || widget.directionDestination == null
        ? const <LatLng>[]
        : [
            _latLng(widget.currentLocation!),
            _latLng(widget.directionDestination!.coordinates),
          ];
    final markers = <Marker>{
      for (final place in widget.places.take(80))
        Marker(
          markerId: MarkerId(place.id),
          position: _latLng(place.coordinates),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            place.id == widget.selectedPlace?.id
                ? BitmapDescriptor.hueOrange
                : _markerHue(place.category),
          ),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: '${place.city} · ${place.rating} ★',
            onTap: () => widget.onPlaceSelected(place),
          ),
          onTap: () => widget.onPlaceSelected(place),
        ),
      for (final entry in widget.itinerary.indexed)
        Marker(
          markerId: MarkerId('trip-${entry.$2.id}'),
          position: _latLng(entry.$2.coordinates),
          zIndexInt: 10,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          infoWindow: InfoWindow(
            title: 'Stop ${entry.$1 + 1}: ${entry.$2.name}',
            snippet: entry.$2.city,
          ),
          onTap: () => widget.onPlaceSelected(entry.$2),
        ),
    };

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _latLng(widget.currentLocation ?? const GeoPoint(5.2, 11.7)),
        zoom: widget.currentLocation == null ? 5.8 : 12,
      ),
      markers: markers,
      polylines: {
        if (routePoints.length > 1)
          Polyline(
            polylineId: const PolylineId('itinerary'),
            points: routePoints,
            color: AppColors.clay,
            width: 5,
            geodesic: true,
          ),
        if (directionPoints.length > 1)
          Polyline(
            polylineId: const PolylineId('directions-preview'),
            points: directionPoints,
            color: AppColors.gold,
            width: 5,
            geodesic: true,
          ),
      },
      myLocationEnabled: widget.currentLocation != null,
      myLocationButtonEnabled: false,
      compassEnabled: true,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      buildingsEnabled: true,
      onMapCreated: (controller) {
        _controller = controller;
        widget.onControllerReady(controller);
      },
    );
  }

  static LatLng _latLng(GeoPoint point) =>
      LatLng(point.latitude, point.longitude);

  static double _markerHue(PlaceCategory category) => switch (category) {
    PlaceCategory.attraction => BitmapDescriptor.hueGreen,
    PlaceCategory.restaurant => BitmapDescriptor.hueOrange,
    PlaceCategory.hotel => BitmapDescriptor.hueAzure,
    PlaceCategory.culture => BitmapDescriptor.hueViolet,
    PlaceCategory.entertainment => BitmapDescriptor.hueMagenta,
    PlaceCategory.emergency => BitmapDescriptor.hueRed,
  };
}
