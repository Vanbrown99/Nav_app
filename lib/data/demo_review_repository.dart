import 'package:nyetam/domain/review.dart';

abstract interface class ReviewRepository {
  Future<List<Review>> getForPlace(String placeId);
  Future<void> submit(Review review);
  Future<void> report(String reviewId);
}

class DemoReviewRepository implements ReviewRepository {
  final List<Review> _reviews = List.of(_seedReviews);
  final Set<String> _reportedReviewIds = {};

  @override
  Future<List<Review>> getForPlace(String placeId) async {
    return _reviews
        .where((review) => review.placeId == placeId)
        .toList(growable: false);
  }

  @override
  Future<void> submit(Review review) async {
    _reviews.insert(0, review);
  }

  @override
  Future<void> report(String reviewId) async {
    _reportedReviewIds.add(reviewId);
  }

  static const _seedReviews = <Review>[
    Review(
      id: 'review-lobe-1',
      placeId: 'lobe-falls',
      authorName: 'Mireille N.',
      rating: 5,
      comment:
          'The canoe approach was calm and the local guide explained the coastal traditions clearly. Go early for softer light.',
      dateLabel: '12 September 2026',
      helpfulCount: 24,
      isVerifiedVisit: true,
    ),
    Review(
      id: 'review-lobe-2',
      placeId: 'lobe-falls',
      authorName: 'Daniel K.',
      rating: 4,
      comment:
          'A remarkable landscape. The path can be slippery after rain, so wear shoes with good grip.',
      dateLabel: '28 August 2026',
      helpfulCount: 11,
      isVerifiedVisit: true,
    ),
    Review(
      id: 'review-museum-1',
      placeId: 'national-museum',
      authorName: 'Amina B.',
      rating: 5,
      comment:
          'A thoughtful introduction to the country’s regions. Allow at least two hours for the collections.',
      dateLabel: '03 September 2026',
      helpfulCount: 18,
      isVerifiedVisit: true,
    ),
    Review(
      id: 'review-mount-1',
      placeId: 'mount-cameroon',
      authorName: 'Chris T.',
      rating: 5,
      comment:
          'Demanding but unforgettable. Our certified guide paced the climb well and carried enough water for the group.',
      dateLabel: '19 August 2026',
      helpfulCount: 31,
      isVerifiedVisit: true,
    ),
  ];
}
