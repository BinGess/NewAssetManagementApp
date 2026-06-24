import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/data/services/backend_asset_api.dart';
import 'package:new_asset_management_app/data/services/backend_auth_service.dart';
import 'package:new_asset_management_app/providers/auth_provider.dart';
import 'package:new_asset_management_app/providers/backend_data_providers.dart';

void main() {
  group('backend data providers', () {
    test('list assets uses the authenticated access token', () async {
      final api = _FakeBackendAssetApi();
      final container = ProviderContainer(overrides: [
        backendAuthServiceProvider.overrideWithValue(
          _FakeBackendAuthService(_session()),
        ),
        backendAssetApiProvider.overrideWithValue(api),
      ]);
      addTearDown(container.dispose);

      final assets = await container.read(backendAssetsProvider.future);

      expect(api.lastAccessToken, 'access-token');
      expect(assets.single.id, 'asset-1');
    });

    test('list assets returns empty when signed out', () async {
      final api = _FakeBackendAssetApi();
      final container = ProviderContainer(overrides: [
        backendAuthServiceProvider.overrideWithValue(
          _FakeBackendAuthService(null),
        ),
        backendAssetApiProvider.overrideWithValue(api),
      ]);
      addTearDown(container.dispose);

      final assets = await container.read(backendAssetsProvider.future);

      expect(assets, isEmpty);
      expect(api.lastAccessToken, isNull);
    });
  });
}

class _FakeBackendAuthService implements BackendAuthService {
  final BackendSession? session;

  _FakeBackendAuthService(this.session);

  @override
  Future<BackendSession?> restoreSession() async => session;

  @override
  Future<BackendSession> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BackendSession> register({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeBackendAssetApi implements BackendAssetApi {
  String? lastAccessToken;

  @override
  Future<List<BackendAsset>> listAssets(String accessToken) async {
    lastAccessToken = accessToken;
    return [
      BackendAsset(
        id: 'asset-1',
        name: '基金账户',
        typeId: 'type-1',
        amount: '4123.4000',
        currency: 'CNY',
        valuationDate: DateTime.utc(2026, 6, 23),
        version: 1,
      ),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

BackendSession _session() {
  return const BackendSession(
    user: BackendUser(id: 'user-1', email: 'family@example.com'),
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );
}
