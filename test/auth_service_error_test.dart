import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyetam/services/auth_service.dart';

void main() {
  test('turns FastAPI validation details into a readable message', () async {
    final service = ApiAuthService(
      baseUrl: 'http://test',
      storage: const FlutterSecureStorage(),
      client: MockClient(
        (_) async => http.Response(
          '''{"detail":[{"type":"value_error","loc":["body","password"],"msg":"Value error, Password must include an uppercase letter","ctx":{"error":"Password must include an uppercase letter"}}]}''',
          422,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );

    expect(
      () => service.register(
        fullName: 'Brown Traveler',
        email: 'brown@example.com',
        password: '12345678',
      ),
      throwsA(
        isA<AuthException>().having(
          (error) => error.message,
          'message',
          'Password must include an uppercase letter',
        ),
      ),
    );
  });
}
