import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_guide_repository.dart';
import 'package:nyetam/presentation/guides_controller.dart';

void main() {
  test('filters guides and submits a valid inquiry', () async {
    final controller = GuidesController(repository: DemoGuideRepository());
    await controller.load();

    controller.selectLanguage('Pidgin English');
    expect(controller.visibleGuides.map((guide) => guide.id), [
      'guide-estelle',
    ]);

    final guide = controller.visibleGuides.single;
    await controller.requestGuide(
      guide: guide,
      travelerName: 'Yann',
      partySize: 2,
      tripDetails: 'A guided Mount Cameroon day hike in November.',
    );
    expect(controller.hasRequested(guide), isTrue);
  });
}
