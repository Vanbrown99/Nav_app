import 'package:nyetam/domain/place.dart';

class TourGuide extends TourismEntity {
  const TourGuide({
    required super.id,
    required super.name,
    required this.city,
    required this.region,
    required this.bio,
    required this.imageUrl,
    required this.languages,
    required this.areasCovered,
    required this.services,
    required this.yearsExperience,
    required this.priceLabel,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
  });

  final String city;
  final String region;
  final String bio;
  final String imageUrl;
  final List<String> languages;
  final List<String> areasCovered;
  final List<String> services;
  final int yearsExperience;
  final String priceLabel;
  final double rating;
  final int reviewCount;
  final bool isVerified;
}

class GuideInquiry {
  const GuideInquiry({
    required this.guideId,
    required this.travelerName,
    required this.partySize,
    required this.tripDetails,
  });

  final String guideId;
  final String travelerName;
  final int partySize;
  final String tripDetails;
}
