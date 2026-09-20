import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/data/demo_review_repository.dart';
import 'package:nyetam/presentation/reviews_controller.dart';

void main() {
  test('submits a valid review and recalculates the average', () async {
    final places = await DemoPlaceRepository().getPlaces();
    final place = places.firstWhere((item) => item.id == 'lobe-falls');
    final controller = ReviewsController(repository: DemoReviewRepository());
    await controller.loadForPlace(place.id);

    await controller.submit(
      place: place,
      rating: 3,
      comment: 'Beautiful setting with a very helpful local guide.',
    );

    expect(controller.reviewsFor(place.id).first.authorName, 'You');
    expect(controller.averageRating(place), 4.0);
  });

  test('rejects comments that are too short', () async {
    final place = (await DemoPlaceRepository().getPlaces()).first;
    final controller = ReviewsController(repository: DemoReviewRepository());

    expect(
      () => controller.submit(place: place, rating: 5, comment: 'Nice'),
      throwsArgumentError,
    );
  });
}
