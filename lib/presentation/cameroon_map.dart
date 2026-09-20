import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/domain/cameroon_region.dart';
import 'package:nyetam/domain/place.dart';

class CameroonMapProjection {
  const CameroonMapProjection._();

  static const double minLatitude = 1.5;
  static const double maxLatitude = 13.2;
  static const double minLongitude = 8.2;
  static const double maxLongitude = 16.3;

  static Offset project(
    GeoPoint point,
    Size size, {
    EdgeInsets padding = const EdgeInsets.all(24),
  }) {
    final drawableWidth = size.width - padding.horizontal;
    final drawableHeight = size.height - padding.vertical;
    final longitudeRatio =
        (point.longitude - minLongitude) / (maxLongitude - minLongitude);
    final latitudeRatio =
        (maxLatitude - point.latitude) / (maxLatitude - minLatitude);
    return Offset(
      padding.left + longitudeRatio.clamp(0, 1) * drawableWidth,
      padding.top + latitudeRatio.clamp(0, 1) * drawableHeight,
    );
  }
}

class CameroonMapCanvas extends StatelessWidget {
  const CameroonMapCanvas({
    super.key,
    required this.places,
    required this.onPlaceSelected,
    this.selectedPlace,
    this.currentLocation,
    this.itinerary = const [],
    this.routePoints = const [],
    this.directionDestination,
    this.maxMarkers = 24,
    this.compact = false,
  });

  final List<Place> places;
  final ValueChanged<Place> onPlaceSelected;
  final Place? selectedPlace;
  final GeoPoint? currentLocation;
  final List<Place> itinerary;
  final List<GeoPoint> routePoints;
  final Place? directionDestination;
  final int maxMarkers;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final displayed = places.take(maxMarkers).toList();
        if (selectedPlace != null &&
            !displayed.any((place) => place.id == selectedPlace!.id)) {
          displayed.add(selectedPlace!);
        }
        for (final stop in itinerary) {
          if (!displayed.any((place) => place.id == stop.id)) {
            displayed.add(stop);
          }
        }

        return ClipRect(
          child: CustomPaint(
            painter: _CameroonMapPainter(
              itinerary: routePoints.isNotEmpty
                  ? routePoints
                  : itinerary.map((place) => place.coordinates).toList(),
              directionRoute: directionDestination == null
                  ? const []
                  : [
                      currentLocation ?? const GeoPoint(3.8667, 11.5167),
                      directionDestination!.coordinates,
                    ],
              currentLocation: currentLocation,
              compact: compact,
            ),
            child: Stack(
              children: [
                ...displayed.asMap().entries.map((entry) {
                  final place = entry.value;
                  final base = CameroonMapProjection.project(
                    place.coordinates,
                    size,
                    padding: compact
                        ? const EdgeInsets.all(18)
                        : const EdgeInsets.fromLTRB(24, 145, 24, 28),
                  );
                  final itineraryIndex = itinerary.indexWhere(
                    (item) => item.id == place.id,
                  );
                  final nearbyIndex = displayed.take(entry.key).where((item) {
                    return (item.coordinates.latitude -
                                    place.coordinates.latitude)
                                .abs() <
                            .12 &&
                        (item.coordinates.longitude -
                                    place.coordinates.longitude)
                                .abs() <
                            .12;
                  }).length;
                  final jitter = itineraryIndex >= 0
                      ? Offset.zero
                      : _markerJitter(nearbyIndex);
                  return Positioned(
                    left: base.dx + jitter.dx - 19,
                    top: base.dy + jitter.dy - 19,
                    child: _GeoMarker(
                      place: place,
                      selected: selectedPlace?.id == place.id,
                      itineraryNumber: itineraryIndex < 0
                          ? null
                          : itineraryIndex + 1,
                      onTap: () => onPlaceSelected(place),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Offset _markerJitter(int nearbyIndex) {
    if (nearbyIndex == 0) return Offset.zero;
    final angle = nearbyIndex * 2.39996;
    final radius = 10 + math.sqrt(nearbyIndex) * 11;
    return Offset(math.cos(angle) * radius, math.sin(angle) * radius);
  }
}

class _GeoMarker extends StatelessWidget {
  const _GeoMarker({
    required this.place,
    required this.selected,
    required this.itineraryNumber,
    required this.onTap,
  });

  final Place place;
  final bool selected;
  final int? itineraryNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: place.name,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: selected ? 44 : 38,
          height: selected ? 44 : 38,
          decoration: BoxDecoration(
            color: itineraryNumber != null
                ? AppColors.clay
                : selected
                ? AppColors.gold
                : AppColors.forest,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: itineraryNumber == null
                ? Icon(place.category.icon, size: 18, color: Colors.white)
                : Text(
                    '$itineraryNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _CameroonMapPainter extends CustomPainter {
  const _CameroonMapPainter({
    required this.itinerary,
    required this.directionRoute,
    required this.currentLocation,
    required this.compact,
  });

  final List<GeoPoint> itinerary;
  final List<GeoPoint> directionRoute;
  final GeoPoint? currentLocation;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFDDE9E0),
    );
    _drawGrid(canvas, size);
    _drawCountry(canvas, size);
    _drawRegionalLabels(canvas, size);
    _drawRoute(canvas, size, itinerary, AppColors.gold, 6);
    _drawRoute(canvas, size, directionRoute, AppColors.clay, 4);
    _drawCurrentLocation(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB7C9A8).withValues(alpha: .32)
      ..strokeWidth = 1;
    for (var index = 1; index < 6; index++) {
      final x = size.width * index / 6;
      final y = size.height * index / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawCountry(Canvas canvas, Size size) {
    const outline = [
      GeoPoint(2.0, 9.0),
      GeoPoint(1.7, 9.8),
      GeoPoint(2.2, 11.2),
      GeoPoint(2.1, 14.0),
      GeoPoint(3.8, 15.2),
      GeoPoint(6.3, 14.6),
      GeoPoint(8.5, 14.4),
      GeoPoint(10.8, 14.3),
      GeoPoint(12.9, 14.1),
      GeoPoint(12.3, 12.7),
      GeoPoint(10.0, 12.1),
      GeoPoint(8.0, 11.4),
      GeoPoint(6.0, 10.6),
      GeoPoint(4.5, 9.7),
    ];
    final padding = compact
        ? const EdgeInsets.all(18)
        : const EdgeInsets.fromLTRB(24, 145, 24, 28);
    final path = Path();
    for (var index = 0; index < outline.length; index++) {
      final point = CameroonMapProjection.project(
        outline[index],
        size,
        padding: padding,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFC4D8B8));
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.canopy.withValues(alpha: .55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawRegionalLabels(Canvas canvas, Size size) {
    if (compact) return;
    for (final region in cameroonRegions) {
      final point = CameroonMapProjection.project(
        region.center,
        size,
        padding: const EdgeInsets.fromLTRB(24, 145, 24, 28),
      );
      final painter = TextPainter(
        text: TextSpan(
          text: region.name.toUpperCase(),
          style: TextStyle(
            color: AppColors.ink.withValues(alpha: .46),
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: .5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, point + const Offset(7, -5));
    }
  }

  void _drawRoute(
    Canvas canvas,
    Size size,
    List<GeoPoint> points,
    Color color,
    double width,
  ) {
    if (points.length < 2) return;
    final padding = compact
        ? const EdgeInsets.all(18)
        : const EdgeInsets.fromLTRB(24, 145, 24, 28);
    final path = Path();
    for (var index = 0; index < points.length; index++) {
      final point = CameroonMapProjection.project(
        points[index],
        size,
        padding: padding,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: .85)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = width + 3,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = width,
    );
  }

  void _drawCurrentLocation(Canvas canvas, Size size) {
    final location = currentLocation;
    if (location == null) return;
    final point = CameroonMapProjection.project(
      location,
      size,
      padding: compact
          ? const EdgeInsets.all(18)
          : const EdgeInsets.fromLTRB(24, 145, 24, 28),
    );
    canvas.drawCircle(
      point,
      10,
      Paint()..color = AppColors.forest.withValues(alpha: .2),
    );
    canvas.drawCircle(point, 5, Paint()..color = AppColors.forest);
    canvas.drawCircle(
      point,
      5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _CameroonMapPainter oldDelegate) {
    return oldDelegate.itinerary != itinerary ||
        oldDelegate.directionRoute != directionRoute ||
        oldDelegate.currentLocation != currentLocation ||
        oldDelegate.compact != compact;
  }
}
