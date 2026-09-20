import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:nyetam/domain/auth_user.dart';
import 'package:nyetam/services/auth_service.dart';
import 'package:nyetam/services/google_identity_service.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthService service,
    GoogleIdentityService? googleIdentity,
  }) : _service = service,
       _googleIdentity = googleIdentity;

  final AuthService _service;
  final GoogleIdentityService? _googleIdentity;
  StreamSubscription<String>? _googleSubscription;
  AuthStatus _status = AuthStatus.unauthenticated;
  AuthUser? _user;
  String? _error;

  AuthStatus get status => _status;
  AuthUser? get user => _user;
  String? get error => _error;
  bool get isBusy => _status == AuthStatus.authenticating;
  bool get googleConfigured => _googleIdentity?.isConfigured ?? false;
  bool get googleSupportsAuthenticate =>
      _googleIdentity?.supportsAuthenticate ?? false;

  Future<void> initializeGoogle() async {
    final identity = _googleIdentity;
    if (identity == null || !identity.isConfigured) return;
    try {
      await identity.initialize();
      if (!identity.supportsAuthenticate) {
        _googleSubscription ??= identity.idTokens.listen(exchangeGoogleToken);
      }
    } catch (_) {
      _error = 'Google Sign-In could not be initialized.';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) {
    return _authenticate(
      () => _service.login(email: email, password: password),
    );
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _authenticate(
      () => _service.register(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );
  }

  Future<bool> signInWithGoogle() async {
    final identity = _googleIdentity;
    if (identity == null) {
      _error = 'Google Sign-In is not configured yet.';
      notifyListeners();
      return false;
    }
    try {
      final idToken = await identity.authenticate();
      return exchangeGoogleToken(idToken);
    } on AuthException catch (error) {
      _error = error.message;
      notifyListeners();
      return false;
    } catch (_) {
      _error = 'Google Sign-In was cancelled or unavailable.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> exchangeGoogleToken(String idToken) {
    return _authenticate(() => _service.loginWithGoogle(idToken: idToken));
  }

  Future<bool> _authenticate(Future<AuthSession> Function() request) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();
    try {
      final session = await request();
      _user = session.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on AuthException catch (error) {
      _error = error.message;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    await _googleIdentity?.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    _googleSubscription?.cancel();
    _googleIdentity?.dispose();
    super.dispose();
  }
}
