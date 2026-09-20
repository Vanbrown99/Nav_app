import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/data/demo_review_repository.dart';
import 'package:nyetam/presentation/reviews_controller.dart';
import 'package:nyetam/presentation/reviews_section.dart';

void main() {
  testWidgets('traveler can publish a five-star review', (tester) async {
    final place = (await DemoPlaceRepository().getPlaces()).firstWhere(
      (item) => item.id == 'lobe-falls',
    );
    final controller = ReviewsController(repository: DemoReviewRepository());
    await controller.loadForPlace(place.id);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReviewsSection(place: place, controller: controller),
          ),
        ),
      ),
    );

    expect(find.text('Mireille N.'), findsOneWidget);
    await tester.tap(find.text('Write a review'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('5 stars'));
    await tester.enterText(
      find.byType(TextField),
      'The waterfall and local guide made this an excellent visit.',
    );
    await tester.tap(find.text('Publish review'));
    await tester.pumpAndSettle();

    expect(find.text('You'), findsOneWidget);
    expect(controller.totalReviewCount(place), 317);
  });
}
