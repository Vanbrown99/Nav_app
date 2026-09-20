import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:nyetam/data/demo_event_repository.dart';
import 'package:nyetam/domain/tourism_event.dart';

class EventsController extends ChangeNotifier {
  EventsController({required EventRepository repository})
    : _repository = repository;

  final EventRepository _repository;
  final Set<String> _itineraryEventIds = {};
  List<TourismEvent> _events = [];
  bool _isLoading = false;

  UnmodifiableListView<TourismEvent> get events =>
      UnmodifiableListView(_events);
  bool get isLoading => _isLoading;
  List<TourismEvent> get itineraryEvents => _events
      .where((event) => _itineraryEventIds.contains(event.id))
      .toList(growable: false);

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _events = await _repository.getUpcomingEvents();
    _isLoading = false;
    notifyListeners();
  }

  bool isInItinerary(TourismEvent event) =>
      _itineraryEventIds.contains(event.id);

  void toggleItinerary(TourismEvent event) {
    if (!_itineraryEventIds.add(event.id)) {
      _itineraryEventIds.remove(event.id);
    }
    notifyListeners();
  }
}
