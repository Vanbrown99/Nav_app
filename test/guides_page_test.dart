import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_guide_repository.dart';
import 'package:nyetam/presentation/guides_controller.dart';
import 'package:nyetam/presentation/guides_page.dart';

void main() {
  testWidgets('traveler opens a verified guide and sends a request', (
    tester,
  ) async {
    final controller = GuidesController(repository: DemoGuideRepository());
    await controller.load();

    await tester.pumpWidget(
      MaterialApp(home: GuidesPage(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Estelle Manka'));
    await tester.pumpAndSettle();
    expect(
      find.text('Identity and professional information verified by Mboa Nav.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Request this guide'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Yann');
    await tester.enterText(
      fields.at(1),
      'A guided Mount Cameroon day hike in November.',
    );
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();

    expect(find.text('Request sent'), findsOneWidget);
  });
}
