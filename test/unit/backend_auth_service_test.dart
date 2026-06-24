import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/data/services/backend_api_client.dart';
import 'package:new_asset_management_app/data/services/backend_auth_service.dart';
import 'package:new_asset_management_app/data/services/auth_token_store.dart';

void main() {
  group('BackendAuthService', () {
    late _FakeBackendApiClient api;
    late _FakeAuthTokenStore store;
    late BackendAuthService service;

    setUp(() {
      api = _FakeBackendApiClient();
      store = _FakeAuthTokenStore();
      service = BackendAuthService(api: api, tokenStore: store);
    });

    test('login posts credentials and persists returned tokens', () async {
      api.nextJson = {
        'user': {'id': 'user-1', 'email': 'family@example.com'},
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
      };

      final session = await service.login(
        email: ' Family@Example.COM ',
        password: 'correct horse battery staple',
      );

      expect(api.requests.single.path, '/auth/login');
      expect(api.requests.single.body, {
        'email': 'family@example.com',
        'password': 'correct horse battery staple',
        'deviceName': 'NewAssetManagementApp',
      });
      expect(session.user.email, 'family@example.com');
      expect(store.accessToken, 'access-token');
      expect(store.refreshToken, 'refresh-token');
      expect(store.email, 'family@example.com');
    });

    test('register posts credentials and persists returned tokens', () async {
      api.nextJson = {
        'user': {'id': 'user-1', 'email': 'family@example.com'},
        'accessToken': 'access-token',
        'refreshToken': 'refresh-token',
      };

      await service.register(
        email: 'family@example.com',
        password: 'correct horse battery staple',
      );

      expect(api.requests.single.path, '/auth/register');
      expect(store.accessToken, 'access-token');
      expect(store.refreshToken, 'refresh-token');
    });

    test('restoreSession refreshes and rotates stored refresh token', () async {
      store.refreshToken = 'old-refresh';
      api.nextJson = {
        'user': {'id': 'user-1', 'email': 'family@example.com'},
        'accessToken': 'new-access',
        'refreshToken': 'new-refresh',
      };

      final session = await service.restoreSession();

      expect(api.requests.single.path, '/auth/refresh');
      expect(api.requests.single.body, {'refreshToken': 'old-refresh'});
      expect(session?.accessToken, 'new-access');
      expect(store.refreshToken, 'new-refresh');
    });

    test('restoreSession clears tokens when refresh fails', () async {
      store.accessToken = 'stale-access';
      store.refreshToken = 'stale-refresh';
      api.nextError = const BackendApiException(
        statusCode: 401,
        message: 'Unauthorized',
      );

      final session = await service.restoreSession();

      expect(session, isNull);
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });

    test('logout sends the refresh token then clears local tokens', () async {
      store.accessToken = 'access-token';
      store.refreshToken = 'refresh-token';

      await service.logout();

      expect(api.requests.single.path, '/auth/logout');
      expect(api.requests.single.body, {'refreshToken': 'refresh-token'});
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });
  });
}

class _FakeBackendApiClient implements BackendApiClient {
  Object? nextJson;
  BackendApiException? nextError;
  final List<_Request> requests = [];

  @override
  Future<Object?> postJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  }) async {
    requests.add(_Request(path, body));
    if (nextError case final error?) {
      throw error;
    }
    return nextJson;
  }

  @override
  Future<Object?> getJson(String path, {String? accessToken}) {
    throw UnimplementedError();
  }

  @override
  Future<Object?> patchJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String path, {String? accessToken}) {
    throw UnimplementedError();
  }
}

class _Request {
  final String path;
  final Map<String, Object?>? body;

  _Request(this.path, this.body);
}

class _FakeAuthTokenStore implements AuthTokenStore {
  String? accessToken;

  String? refreshToken;

  String? email;

  @override
  Future<AuthTokenSnapshot> read() async => AuthTokenSnapshot(
        accessToken: accessToken,
        refreshToken: refreshToken,
        email: email,
      );

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required String email,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.email = email;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
    email = null;
  }
}
