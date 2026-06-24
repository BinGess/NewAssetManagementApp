import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenSnapshot {
  final String? accessToken;
  final String? refreshToken;
  final String? email;

  const AuthTokenSnapshot({
    required this.accessToken,
    required this.refreshToken,
    required this.email,
  });
}

abstract class AuthTokenStore {
  Future<AuthTokenSnapshot> read();

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required String email,
  });

  Future<void> clear();
}

class SecureAuthTokenStore implements AuthTokenStore {
  static const _accessTokenKey = 'backend_access_token';
  static const _refreshTokenKey = 'backend_refresh_token';
  static const _emailKey = 'backend_account_email';

  final FlutterSecureStorage _storage;

  const SecureAuthTokenStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  @override
  Future<AuthTokenSnapshot> read() async {
    return AuthTokenSnapshot(
      accessToken: await _storage.read(key: _accessTokenKey),
      refreshToken: await _storage.read(key: _refreshTokenKey),
      email: await _storage.read(key: _emailKey),
    );
  }

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required String email,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _emailKey, value: email);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _emailKey);
  }
}
