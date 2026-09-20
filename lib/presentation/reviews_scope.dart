import 'package:flutter/widgets.dart';
import 'package:nyetam/presentation/reviews_controller.dart';

class ReviewsScope extends InheritedNotifier<ReviewsController> {
  const ReviewsScope({
    super.key,
    required ReviewsController controller,
    required super.child,
  }) : super(notifier: controller);

  static ReviewsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ReviewsScope>();
    assert(scope != null, 'ReviewsScope was not found above this context.');
    return scope!.notifier!;
  }
}
