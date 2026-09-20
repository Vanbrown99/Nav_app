import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_place_repository.dart';
import 'package:nyetam/presentation/explore_controller.dart';
import 'package:nyetam/presentation/region_explorer_page.dart';

void main() {
  testWidgets('selecting Adamawa shows its destinations', (tester) async {
    final controller = ExploreController(repository: DemoPlaceRepository());
    await controller.load();

    await tester.pumpWidget(
      MaterialApp(
        home: RegionExplorerPage(
          controller: controller,
          onPlaceSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adamawa'));
    await tester.pumpAndSettle();

    expect(controller.region, 'Adamawa');
    expect(controller.visiblePlaces.length, 4);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('4 destinations'), findsOneWidget);
    expect(find.text('Tello Falls'), findsOneWidget);
    expect(find.text('Lamidat of Ngaoundéré'), findsOneWidget);
  });
}
