import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_event_repository.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/presentation/events_controller.dart';
import 'package:nyetam/presentation/explore_controller.dart';
import 'package:nyetam/presentation/home_shell.dart';

void main() {
  testWidgets('shows a traced route for itinerary stops', (tester) async {
    final controller = ExploreController(repository: DemoPlaceRepository());
    final eventsController = EventsController(
      repository: DemoEventRepository(),
    );
    await controller.load();
    await eventsController.load();
    controller.toggleTripPlace(controller.places.first);
    controller.toggleTripPlace(controller.places[1]);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TripView(
            controller: controller,
            eventsController: eventsController,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 STOPS · CAMEROON'), findsOneWidget);
    expect(find.text('total route'), findsOneWidget);
    expect(find.text('estimated drive'), findsOneWidget);
    expect(find.text('STOP\n1'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();

    expect(find.text('STOP\n2'), findsOneWidget);
  });
}
