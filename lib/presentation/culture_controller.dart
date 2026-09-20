import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:nyetam/data/demo_culture_repository.dart';
import 'package:nyetam/domain/culture_article.dart';

class CultureController extends ChangeNotifier {
  CultureController({required CultureRepository repository})
    : _repository = repository;

  final CultureRepository _repository;
  List<CultureArticle> _articles = [];
  CultureTopic? _topic;
  String? _region;
  bool _isLoading = false;

  UnmodifiableListView<CultureArticle> get articles =>
      UnmodifiableListView(_articles);
  CultureTopic? get topic => _topic;
  String? get region => _region;
  bool get isLoading => _isLoading;

  List<String> get regions =>
      {for (final article in _articles) article.region}.toList(growable: false)
        ..sort();

  List<CultureArticle> get visibleArticles => _articles
      .where((article) {
        final matchesTopic = _topic == null || article.topic == _topic;
        final matchesRegion =
            _region == null ||
            article.region == _region ||
            article.region == 'All regions';
        return matchesTopic && matchesRegion;
      })
      .toList(growable: false);

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _articles = await _repository.getArticles();
    _isLoading = false;
    notifyListeners();
  }

  void selectTopic(CultureTopic? topic) {
    _topic = topic;
    notifyListeners();
  }

  void selectRegion(String? region) {
    _region = region;
    notifyListeners();
  }
}
