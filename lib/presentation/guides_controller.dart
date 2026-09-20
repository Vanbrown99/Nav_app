import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:nyetam/data/demo_guide_repository.dart';
import 'package:nyetam/domain/tour_guide.dart';

class GuidesController extends ChangeNotifier {
  GuidesController({required GuideRepository repository})
    : _repository = repository;

  final GuideRepository _repository;
  final Set<String> _requestedGuideIds = {};
  List<TourGuide> _guides = [];
  String? _region;
  String? _language;
  bool _isLoading = false;

  UnmodifiableListView<TourGuide> get guides => UnmodifiableListView(_guides);
  String? get region => _region;
  String? get language => _language;
  bool get isLoading => _isLoading;

  List<String> get regions =>
      {for (final guide in _guides) guide.region}.toList(growable: false)
        ..sort();

  List<String> get languages =>
      {for (final guide in _guides) ...guide.languages}.toList(growable: false)
        ..sort();

  List<TourGuide> get visibleGuides => _guides
      .where((guide) {
        final matchesRegion = _region == null || guide.region == _region;
        final matchesLanguage =
            _language == null || guide.languages.contains(_language);
        return matchesRegion && matchesLanguage;
      })
      .toList(growable: false);

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _guides = (await _repository.getVerifiedGuides())
        .where((guide) => guide.isVerified)
        .toList(growable: false);
    _isLoading = false;
    notifyListeners();
  }

  void selectRegion(String? region) {
    _region = region;
    notifyListeners();
  }

  void selectLanguage(String? language) {
    _language = language;
    notifyListeners();
  }

  bool hasRequested(TourGuide guide) => _requestedGuideIds.contains(guide.id);

  Future<void> requestGuide({
    required TourGuide guide,
    required String travelerName,
    required int partySize,
    required String tripDetails,
  }) async {
    final normalizedName = travelerName.trim();
    final normalizedDetails = tripDetails.trim();
    if (normalizedName.length < 2) {
      throw ArgumentError.value(
        travelerName,
        'travelerName',
        'Enter your name',
      );
    }
    if (partySize < 1 || partySize > 20) {
      throw ArgumentError.value(partySize, 'partySize', 'Must be from 1 to 20');
    }
    if (normalizedDetails.length < 10) {
      throw ArgumentError.value(
        tripDetails,
        'tripDetails',
        'Add at least 10 characters about your trip',
      );
    }

    await _repository.submitInquiry(
      GuideInquiry(
        guideId: guide.id,
        travelerName: normalizedName,
        partySize: partySize,
        tripDetails: normalizedDetails,
      ),
    );
    _requestedGuideIds.add(guide.id);
    notifyListeners();
  }
}
