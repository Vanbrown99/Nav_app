import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_auth_service.dart';
import 'package:nyetam/presentation/auth_controller.dart';
import 'package:nyetam/presentation/auth_page.dart';

void main() {
  testWidgets('explains strong password requirements before registration', (
    tester,
  ) async {
    final controller = AuthController(service: DemoAuthService());
    await tester.pumpWidget(
      MaterialApp(home: AuthPage(controller: controller)),
    );

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Brown Traveler');
    await tester.enterText(fields.at(1), 'brown@example.com');
    await tester.enterText(fields.at(2), '12345678');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Add at least one uppercase letter'), findsOneWidget);
    expect(controller.status, AuthStatus.unauthenticated);
  });

  testWidgets('explains when Google Sign-In is not configured', (tester) async {
    final controller = AuthController(service: DemoAuthService());
    await tester.pumpWidget(
      MaterialApp(home: AuthPage(controller: controller)),
    );

    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();

    expect(find.text('Google Sign-In is not configured yet.'), findsOneWidget);
  });
}
