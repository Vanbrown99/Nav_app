import 'package:nyetam/domain/place.dart';

class TourismEvent extends TourismEntity {
  const TourismEvent({
    required super.id,
    required super.name,
    required this.description,
    required this.city,
    required this.region,
    required this.dateLabel,
    required this.startTime,
    required this.venue,
    required this.organizer,
    required this.ticketLabel,
    required this.imageUrl,
    required this.coordinates,
    required this.category,
  });

  final String description;
  final String city;
  final String region;
  final String dateLabel;
  final String startTime;
  final String venue;
  final String organizer;
  final String ticketLabel;
  final String imageUrl;
  final GeoPoint coordinates;
  final String category;
}
