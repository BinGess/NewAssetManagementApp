import 'backend_api_client.dart';
import 'auth_token_store.dart';

class BackendUser {
  final String id;
  final String email;

  const BackendUser({
    required this.id,
    required this.email,
  });

  factory BackendUser.fromJson(Map<String, Object?> json) {
    return BackendUser(
      id: json['id']! as String,
      email: json['email']! as String,
    );
  }
}

class BackendSession {
  final BackendUser user;
  final String accessToken;
  final String refreshToken;

  const BackendSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory BackendSession.fromJson(Map<String, Object?> json) {
    return BackendSession(
      user: BackendUser.fromJson(json['user']! as Map<String, Object?>),
      accessToken: json['accessToken']! as String,
      refreshToken: json['refreshToken']! as String,
    );
  }
}

class BackendAuthService {
  static const defaultDeviceName = 'NewAssetManagementApp';

  final BackendApiClient api;
  final AuthTokenStore tokenStore;

  BackendAuthService({
    required this.api,
    required this.tokenStore,
  });

  Future<BackendSession> login({
    required String email,
    required String password,
  }) {
    return _authenticate(
      '/auth/login',
      email: email,
      password: password,
    );
  }

  Future<BackendSession> register({
    required String email,
    required String password,
  }) {
    return _authenticate(
      '/auth/register',
      email: email,
      password: password,
    );
  }

  Future<BackendSession?> restoreSession() async {
    final snapshot = await tokenStore.read();
    final refreshToken = snapshot.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final response = await api.postJson(
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
      );
      final session =
          BackendSession.fromJson(response! as Map<String, Object?>);
      await _save(session);
      return session;
    } on BackendApiException {
      await tokenStore.clear();
      return null;
    }
  }

  Future<void> logout() async {
    final snapshot = await tokenStore.read();
    final refreshToken = snapshot.refreshToken;
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await api.postJson(
          '/auth/logout',
          body: {'refreshToken': refreshToken},
        );
      }
    } finally {
      await tokenStore.clear();
    }
  }

  Future<BackendSession> _authenticate(
    String path, {
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final response = await api.postJson(
      path,
      body: {
        'email': normalizedEmail,
        'password': password,
        'deviceName': defaultDeviceName,
      },
    );
    final session = BackendSession.fromJson(response! as Map<String, Object?>);
    await _save(session);
    return session;
  }

  Future<void> _save(BackendSession session) {
    return tokenStore.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      email: session.user.email,
    );
  }
}
