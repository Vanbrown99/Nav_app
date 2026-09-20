import 'package:flutter/material.dart';

enum PlaceCategory {
  attraction('Attractions', Icons.landscape_outlined),
  restaurant('Restaurants', Icons.restaurant_outlined),
  hotel('Stays', Icons.hotel_outlined),
  culture('Culture', Icons.museum_outlined),
  entertainment('Leisure', Icons.theater_comedy_outlined),
  emergency('Essential', Icons.local_hospital_outlined);

  const PlaceCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

abstract class TourismEntity {
  const TourismEntity({required this.id, required this.name});

  final String id;
  final String name;
}

class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class Place extends TourismEntity {
  const Place({
    required super.id,
    required super.name,
    required this.city,
    required this.region,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.coordinates,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.travelMinutes,
    required this.openingHours,
    required this.priceLabel,
    required this.tags,
    this.isOpen = true,
  });

  final String city;
  final String region;
  final PlaceCategory category;
  final String description;
  final String imageUrl;
  final GeoPoint coordinates;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final int travelMinutes;
  final String openingHours;
  final String priceLabel;
  final List<String> tags;
  final bool isOpen;
}

class TripPlan extends TourismEntity {
  const TripPlan({
    required super.id,
    required super.name,
    required this.dateLabel,
    required this.places,
  });

  final String dateLabel;
  final List<Place> places;
}
