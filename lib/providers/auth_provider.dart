import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/auth_token_store.dart';
import '../data/services/backend_api_client.dart';
import '../data/services/backend_asset_api.dart';
import '../data/services/backend_auth_service.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? email;
  final String? accessToken;
  final String? errorMessage;

  const AuthState._({
    required this.status,
    this.email,
    this.accessToken,
    this.errorMessage,
  });

  const AuthState.authenticated({
    required String email,
    required String accessToken,
  }) : this._(
          status: AuthStatus.authenticated,
          email: email,
          accessToken: accessToken,
        );

  const AuthState.unauthenticated({String? errorMessage})
      : this._(
          status: AuthStatus.unauthenticated,
          errorMessage: errorMessage,
        );

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

final backendBaseUrlProvider = Provider<String>((ref) {
  return const String.fromEnvironment(
    'ASSET_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000/api/v1',
  );
});

final backendApiClientProvider = Provider<BackendApiClient>((ref) {
  return HttpBackendApiClient(baseUrl: ref.watch(backendBaseUrlProvider));
});

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return const SecureAuthTokenStore();
});

final backendAuthServiceProvider = Provider<BackendAuthService>((ref) {
  return BackendAuthService(
    api: ref.watch(backendApiClientProvider),
    tokenStore: ref.watch(authTokenStoreProvider),
  );
});

final backendAssetApiProvider = Provider<BackendAssetApi>((ref) {
  return BackendAssetApi(ref.watch(backendApiClientProvider));
});

class AuthNotifier extends AsyncNotifier<AuthState> {
  BackendAuthService get _service => ref.read(backendAuthServiceProvider);

  @override
  Future<AuthState> build() async {
    final session = await _service.restoreSession();
    return _stateFromSession(session);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await _service.login(email: email, password: password);
      return _stateFromSession(session);
    });
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await _service.register(email: email, password: password);
      return _stateFromSession(session);
    });
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AsyncData(AuthState.unauthenticated());
  }

  AuthState _stateFromSession(BackendSession? session) {
    if (session == null) {
      return const AuthState.unauthenticated();
    }
    return AuthState.authenticated(
      email: session.user.email,
      accessToken: session.accessToken,
    );
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
