import 'package:nyetam/domain/place.dart';

class Review extends TourismEntity {
  const Review({
    required super.id,
    required this.placeId,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.dateLabel,
    required this.helpfulCount,
    this.isVerifiedVisit = false,
  }) : super(name: authorName);

  final String placeId;
  final String authorName;
  final int rating;
  final String comment;
  final String dateLabel;
  final int helpfulCount;
  final bool isVerifiedVisit;
}
