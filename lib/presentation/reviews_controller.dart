import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:nyetam/data/demo_review_repository.dart';
import 'package:nyetam/domain/place.dart';
import 'package:nyetam/domain/review.dart';

class ReviewsController extends ChangeNotifier {
  ReviewsController({required ReviewRepository repository})
    : _repository = repository;

  final ReviewRepository _repository;
  final Map<String, List<Review>> _reviewsByPlace = {};
  final Set<String> _reportedReviewIds = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  UnmodifiableListView<Review> reviewsFor(String placeId) {
    return UnmodifiableListView(_reviewsByPlace[placeId] ?? const []);
  }

  Future<void> loadForPlace(String placeId) async {
    _isLoading = true;
    notifyListeners();
    _reviewsByPlace[placeId] = List.of(await _repository.getForPlace(placeId));
    _isLoading = false;
    notifyListeners();
  }

  double averageRating(Place place) {
    final reviews = _reviewsByPlace[place.id] ?? const <Review>[];
    if (reviews.isEmpty) return place.rating;
    final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return double.parse((total / reviews.length).toStringAsFixed(1));
  }

  int totalReviewCount(Place place) {
    final localReviewCount = (_reviewsByPlace[place.id] ?? const <Review>[])
        .where((review) => review.id.startsWith('local-'))
        .length;
    return place.reviewCount + localReviewCount;
  }

  Future<void> submit({
    required Place place,
    required int rating,
    required String comment,
  }) async {
    final normalizedComment = comment.trim();
    if (rating < 1 || rating > 5) {
      throw ArgumentError.value(rating, 'rating', 'Must be between 1 and 5');
    }
    if (normalizedComment.length < 10) {
      throw ArgumentError.value(
        comment,
        'comment',
        'Must contain at least 10 characters',
      );
    }

    final review = Review(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      placeId: place.id,
      authorName: 'You',
      rating: rating,
      comment: normalizedComment,
      dateLabel: 'Today',
      helpfulCount: 0,
      isVerifiedVisit: true,
    );
    await _repository.submit(review);
    _reviewsByPlace.putIfAbsent(place.id, () => []).insert(0, review);
    notifyListeners();
  }

  bool isReported(Review review) => _reportedReviewIds.contains(review.id);

  Future<void> report(Review review) async {
    await _repository.report(review.id);
    _reportedReviewIds.add(review.id);
    notifyListeners();
  }
}
