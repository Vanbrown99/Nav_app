import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nyetam/domain/auth_user.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class AuthService {
  Future<AuthSession> login({required String email, required String password});

  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<AuthSession> loginWithGoogle({required String idToken});

  Future<AuthUser?> restoreSession();
  Future<void> logout();
}

class ApiAuthService implements AuthService {
  ApiAuthService({
    required this.baseUrl,
    http.Client? client,
    FlutterSecureStorage? storage,
  }) : _client = client ?? http.Client(),
       _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'nyetam_access_token';

  final String baseUrl;
  final http.Client _client;
  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession> login({required String email, required String password}) {
    return _authenticate('/api/v1/auth/login', {
      'email': email.trim(),
      'password': password,
    });
  }

  @override
  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _authenticate('/api/v1/auth/register', {
      'full_name': fullName.trim(),
      'email': email.trim(),
      'password': password,
    });
  }

  @override
  Future<AuthSession> loginWithGoogle({required String idToken}) {
    return _authenticate('/api/v1/auth/google', {'id_token': idToken});
  }

  Future<AuthSession> _authenticate(
    String path,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$path'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AuthException(_readErrorMessage(body));
      }
      final session = AuthSession(
        accessToken: body['access_token'] as String,
        user: AuthUser.fromJson(body['user'] as Map<String, dynamic>),
      );
      await _storage.write(key: _tokenKey, value: session.accessToken);
      return session;
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(
        'Unable to reach Nyetam. Check your connection and try again.',
      );
    }
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return null;
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/v1/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        await logout();
        return null;
      }
      return AuthUser.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() => _storage.delete(key: _tokenKey);
}

String _readErrorMessage(Map<String, dynamic> body) {
  final detail = body['detail'];
  if (detail is String && detail.trim().isNotEmpty) return detail;
  if (detail is List) {
    final messages = detail
        .whereType<Map<String, dynamic>>()
        .map((item) {
          final context = item['ctx'];
          if (context is Map<String, dynamic>) {
            final error = context['error']?.toString();
            if (error != null && error.isNotEmpty) {
              return error.replaceFirst('Value error, ', '');
            }
          }
          return item['msg']?.toString().replaceFirst('Value error, ', '');
        })
        .whereType<String>()
        .where((message) => message.isNotEmpty)
        .toSet();
    if (messages.isNotEmpty) return messages.join('\n');
  }
  return 'Authentication failed. Please check your details.';
}
