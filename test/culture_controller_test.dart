import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_culture_repository.dart';
import 'package:nyetam/domain/culture_article.dart';
import 'package:nyetam/presentation/culture_controller.dart';

void main() {
  test('filters culture articles by topic and region', () async {
    final controller = CultureController(repository: DemoCultureRepository());
    await controller.load();

    controller.selectTopic(CultureTopic.history);
    expect(controller.visibleArticles.map((article) => article.id), [
      'bamoun-kingdom',
    ]);

    controller.selectTopic(null);
    controller.selectRegion('West');
    expect(
      controller.visibleArticles.every(
        (article) =>
            article.region == 'West' || article.region == 'All regions',
      ),
      isTrue,
    );
  });
}
