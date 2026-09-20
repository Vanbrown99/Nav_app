import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/services/location_service.dart';
import 'package:nyetam/services/route_service.dart';

class ExploreController extends ChangeNotifier {
  ExploreController({
    required PlaceRepository repository,
    DistanceCalculator distanceCalculator = const HaversineDistanceCalculator(),
    RouteService? routeService,
  }) : _repository = repository,
       _distanceCalculator = distanceCalculator,
       _routeService = routeService;

  final PlaceRepository _repository;
  final DistanceCalculator _distanceCalculator;
  final RouteService? _routeService;
  final Set<String> _favoriteIds = {};
  final List<Place> _tripPlaces = [];
  List<Place> _places = [];
  PlaceCategory? _category;
  String? _region;
  String _query = '';
  bool _isLoading = false;
  GeoPoint? _currentLocation;
  RoutePlan? _routePlan;
  bool _isRouteLoading = false;

  UnmodifiableListView<Place> get places => UnmodifiableListView(_places);
  UnmodifiableListView<Place> get tripPlaces =>
      UnmodifiableListView(_tripPlaces);
  PlaceCategory? get category => _category;
  String? get region => _region;
  String get query => _query;
  bool get isLoading => _isLoading;
  GeoPoint? get currentLocation => _currentLocation;
  List<GeoPoint> get routePoints =>
      UnmodifiableListView(_routePlan?.points ?? const []);
  bool get isRouteLoading => _isRouteLoading;

  void setCurrentLocation(GeoPoint? location) {
    _currentLocation = location;
    notifyListeners();
  }

  double distanceTo(Place place) {
    final origin = _currentLocation;
    if (origin == null) return place.distanceKm;
    final distance = _distanceCalculator.kilometersBetween(
      origin,
      place.coordinates,
    );
    return double.parse(distance.toStringAsFixed(1));
  }

  double distanceBetween(Place origin, Place destination) {
    final distance = _distanceCalculator.kilometersBetween(
      origin.coordinates,
      destination.coordinates,
    );
    return double.parse(distance.toStringAsFixed(1));
  }

  double get tripDistanceKm {
    final providerDistance = _routePlan?.distanceKm;
    if (providerDistance != null) {
      return double.parse(providerDistance.toStringAsFixed(1));
    }
    var total = 0.0;
    for (var index = 1; index < _tripPlaces.length; index++) {
      total += distanceBetween(_tripPlaces[index - 1], _tripPlaces[index]);
    }
    return double.parse(total.toStringAsFixed(1));
  }

  int get tripEstimatedMinutes =>
      _routePlan?.durationMinutes ?? (tripDistanceKm / 35 * 60).round();

  List<Place> get visiblePlaces {
    final normalizedQuery = _query.toLowerCase();
    return _places.where((place) {
      final matchesCategory = _category == null || place.category == _category;
      final matchesRegion = _region == null || place.region == _region;
      final matchesQuery =
          normalizedQuery.isEmpty ||
          place.name.toLowerCase().contains(normalizedQuery) ||
          place.city.toLowerCase().contains(normalizedQuery) ||
          place.tags.any((tag) => tag.toLowerCase().contains(normalizedQuery));
      return matchesCategory && matchesRegion && matchesQuery;
    }).toList()..sort(
      (first, second) => distanceTo(first).compareTo(distanceTo(second)),
    );
  }

  List<Place> get favorites =>
      _places.where((place) => _favoriteIds.contains(place.id)).toList();

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _places = await _repository.getPlaces();
    _isLoading = false;
    notifyListeners();
  }

  void search(String value) {
    _query = value.trim();
    _region = null;
    notifyListeners();
  }

  void selectRegion(String? value) {
    _region = value;
    _query = '';
    notifyListeners();
  }

  void selectCategory(PlaceCategory? value) {
    _category = value;
    notifyListeners();
  }

  bool isFavorite(Place place) => _favoriteIds.contains(place.id);

  void toggleFavorite(Place place) {
    if (!_favoriteIds.add(place.id)) _favoriteIds.remove(place.id);
    notifyListeners();
  }

  bool isInTrip(Place place) => _tripPlaces.any((item) => item.id == place.id);

  void toggleTripPlace(Place place) {
    if (isInTrip(place)) {
      _tripPlaces.removeWhere((item) => item.id == place.id);
    } else {
      _tripPlaces.add(place);
    }
    unawaited(_refreshRoute());
    notifyListeners();
  }

  void moveTripPlace(int index, int offset) {
    final destinationIndex = index + offset;
    if (index < 0 ||
        index >= _tripPlaces.length ||
        destinationIndex < 0 ||
        destinationIndex >= _tripPlaces.length) {
      return;
    }
    final place = _tripPlaces.removeAt(index);
    _tripPlaces.insert(destinationIndex, place);
    unawaited(_refreshRoute());
    notifyListeners();
  }

  Future<void> _refreshRoute() async {
    final service = _routeService;
    if (service == null || _tripPlaces.length < 2) {
      _routePlan = null;
      return;
    }
    _isRouteLoading = true;
    notifyListeners();
    try {
      _routePlan = await service.computeRoute(
        _tripPlaces.map((place) => place.coordinates).toList(growable: false),
      );
    } catch (_) {
      _routePlan = null;
    } finally {
      _isRouteLoading = false;
      notifyListeners();
    }
  }
}
