import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:nyetam/services/auth_service.dart';

class GoogleIdentityService {
  GoogleIdentityService({
    required this.clientId,
    required this.serverClientId,
    GoogleSignIn? signIn,
  }) : _signIn = signIn ?? GoogleSignIn.instance;

  final String clientId;
  final String serverClientId;
  final GoogleSignIn _signIn;
  final StreamController<String> _idTokens = StreamController.broadcast();
  StreamSubscription<GoogleSignInAuthenticationEvent>? _subscription;
  bool _initialized = false;

  bool get isConfigured => clientId.isNotEmpty || serverClientId.isNotEmpty;
  bool get supportsAuthenticate => _signIn.supportsAuthenticate();
  Stream<String> get idTokens => _idTokens.stream;

  Future<void> initialize() async {
    if (_initialized || !isConfigured) return;
    await _signIn.initialize(
      clientId: clientId.isEmpty ? null : clientId,
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    _subscription = _signIn.authenticationEvents.listen((event) {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final token = event.user.authentication.idToken;
        if (token != null) _idTokens.add(token);
      }
    });
    _initialized = true;
  }

  Future<String> authenticate() async {
    if (!isConfigured) {
      throw const AuthException('Google Sign-In is not configured yet.');
    }
    await initialize();
    if (!supportsAuthenticate) {
      throw const AuthException('Use the Google button to continue.');
    }
    final account = await _signIn.authenticate();
    final token = account.authentication.idToken;
    if (token == null) {
      throw const AuthException('Google did not return an identity token.');
    }
    return token;
  }

  Future<void> signOut() => _signIn.signOut();

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _idTokens.close();
  }
}
