import 'package:flutter_test/flutter_test.dart';
import 'package:nyetam/data/demo_auth_service.dart';
import 'package:nyetam/presentation/auth_controller.dart';

void main() {
  test('registers and authenticates a tourist', () async {
    final controller = AuthController(service: DemoAuthService());

    final success = await controller.register(
      fullName: 'Yann Traveler',
      email: 'yann@example.com',
      password: 'SecurePass123!',
    );

    expect(success, isTrue);
    expect(controller.status, AuthStatus.authenticated);
    expect(controller.user?.email, 'yann@example.com');
  });

  test('surfaces invalid credentials without authenticating', () async {
    final controller = AuthController(service: DemoAuthService());

    final success = await controller.login(
      email: 'traveler@nyetam.cm',
      password: 'incorrect-password',
    );

    expect(success, isFalse);
    expect(controller.status, AuthStatus.unauthenticated);
    expect(controller.error, 'Incorrect email or password.');
  });

  test('exchanges a Google identity token for a Nyetam session', () async {
    final controller = AuthController(service: DemoAuthService());

    final success = await controller.exchangeGoogleToken('valid-google-token');

    expect(success, isTrue);
    expect(controller.status, AuthStatus.authenticated);
    expect(controller.user?.email, 'google.traveler@example.com');
  });
}
