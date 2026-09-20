import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_culture_repository.dart';
import 'package:nyetam/presentation/culture_controller.dart';
import 'package:nyetam/presentation/culture_page.dart';

void main() {
  testWidgets('filters food articles and opens the cultural guide', (
    tester,
  ) async {
    final controller = CultureController(repository: DemoCultureRepository());
    await controller.load();

    await tester.pumpWidget(
      MaterialApp(home: CultureGuidePage(controller: controller)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Food'));
    await tester.pumpAndSettle();

    expect(find.text('Ndolé and the shared table'), findsOneWidget);
    expect(find.text('The Bamoun Kingdom'), findsNothing);

    await tester.tap(find.text('Ndolé and the shared table'));
    await tester.pumpAndSettle();

    expect(find.text('What to expect'), findsOneWidget);
    expect(find.text('At the table'), findsOneWidget);
  });
}
