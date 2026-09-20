import 'package:nyetam/domain/auth_user.dart';
import 'package:nyetam/services/auth_service.dart';

class DemoAuthService implements AuthService {
  final Map<String, ({AuthUser user, String password})> _accounts = {
    'traveler@nyetam.cm': (
      user: const AuthUser(
        id: 'demo-tourist',
        fullName: 'Nyetam Traveler',
        email: 'traveler@nyetam.cm',
        role: UserRole.tourist,
      ),
      password: 'Cameroon123!',
    ),
  };
  AuthUser? _currentUser;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw const AuthException('Incorrect email or password.');
    }
    _currentUser = account.user;
    return AuthSession(accessToken: 'demo-token', user: account.user);
  }

  @override
  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw const AuthException('An account already uses this email.');
    }
    final user = AuthUser(
      id: 'demo-${_accounts.length + 1}',
      fullName: fullName.trim(),
      email: normalizedEmail,
      role: UserRole.tourist,
    );
    _accounts[normalizedEmail] = (user: user, password: password);
    _currentUser = user;
    return AuthSession(accessToken: 'demo-token', user: user);
  }

  @override
  Future<AuthSession> loginWithGoogle({required String idToken}) async {
    if (idToken != 'valid-google-token') {
      throw const AuthException('Google authentication failed.');
    }
    const user = AuthUser(
      id: 'demo-google-tourist',
      fullName: 'Google Traveler',
      email: 'google.traveler@example.com',
      role: UserRole.tourist,
    );
    _currentUser = user;
    return const AuthSession(accessToken: 'demo-google-jwt', user: user);
  }

  @override
  Future<AuthUser?> restoreSession() async => _currentUser;

  @override
  Future<void> logout() async => _currentUser = null;
}
