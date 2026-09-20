import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_event_repository.dart';
import 'package:nyetam/presentation/events_controller.dart';

void main() {
  test('adds and removes an event from the itinerary', () async {
    final controller = EventsController(repository: DemoEventRepository());
    await controller.load();
    final event = controller.events.first;

    controller.toggleItinerary(event);
    expect(controller.itineraryEvents, contains(event));

    controller.toggleItinerary(event);
    expect(controller.itineraryEvents, isEmpty);
  });
}
