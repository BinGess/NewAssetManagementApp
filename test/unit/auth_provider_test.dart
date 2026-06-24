import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/data/services/auth_token_store.dart';
import 'package:new_asset_management_app/data/services/backend_api_client.dart';
import 'package:new_asset_management_app/data/services/backend_auth_service.dart';
import 'package:new_asset_management_app/providers/auth_provider.dart';

void main() {
  group('AuthNotifier', () {
    test('starts unauthenticated when no backend session can be restored',
        () async {
      final service = _FakeBackendAuthService();
      final container = ProviderContainer(overrides: [
        backendAuthServiceProvider.overrideWithValue(service),
      ]);
      addTearDown(container.dispose);

      final state = await container.read(authProvider.future);

      expect(state.status, AuthStatus.unauthenticated);
      expect(service.restoreCallCount, 1);
    });

    test('login marks the user as authenticated', () async {
      final service = _FakeBackendAuthService();
      final container = ProviderContainer(overrides: [
        backendAuthServiceProvider.overrideWithValue(service),
      ]);
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      await container.read(authProvider.notifier).login(
            email: 'family@example.com',
            password: 'correct horse battery staple',
          );

      final state = container.read(authProvider).value!;
      expect(service.loginEmail, 'family@example.com');
      expect(state.status, AuthStatus.authenticated);
      expect(state.email, 'family@example.com');
      expect(state.accessToken, 'access-token');
    });

    test('register marks the user as authenticated', () async {
      final service = _FakeBackendAuthService();
      final container = ProviderContainer(overrides: [
        backendAuthServiceProvider.overrideWithValue(service),
      ]);
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      await container.read(authProvider.notifier).register(
            email: 'family@example.com',
            password: 'correct horse battery staple',
          );

      expect(
          container.read(authProvider).value!.status, AuthStatus.authenticated);
      expect(service.registerEmail, 'family@example.com');
    });

    test('logout clears the authenticated state', () async {
      final service = _FakeBackendAuthService(
        restoredSession: _session(email: 'family@example.com'),
      );
      final container = ProviderContainer(overrides: [
        backendAuthServiceProvider.overrideWithValue(service),
      ]);
      addTearDown(container.dispose);

      expect((await container.read(authProvider.future)).status,
          AuthStatus.authenticated);

      await container.read(authProvider.notifier).logout();

      expect(service.logoutCallCount, 1);
      expect(container.read(authProvider).value!.status,
          AuthStatus.unauthenticated);
    });
  });
}

class _FakeBackendAuthService implements BackendAuthService {
  final BackendSession? restoredSession;
  int restoreCallCount = 0;
  int logoutCallCount = 0;
  String? loginEmail;
  String? registerEmail;

  _FakeBackendAuthService({this.restoredSession});

  @override
  Future<BackendSession?> restoreSession() async {
    restoreCallCount++;
    return restoredSession;
  }

  @override
  Future<BackendSession> login({
    required String email,
    required String password,
  }) async {
    loginEmail = email;
    return _session(email: email);
  }

  @override
  Future<BackendSession> register({
    required String email,
    required String password,
  }) async {
    registerEmail = email;
    return _session(email: email);
  }

  @override
  Future<void> logout() async {
    logoutCallCount++;
  }

  @override
  BackendApiClient get api => throw UnimplementedError();

  @override
  AuthTokenStore get tokenStore => throw UnimplementedError();
}

BackendSession _session({required String email}) {
  return BackendSession(
    user: BackendUser(id: 'user-1', email: email),
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );
}
