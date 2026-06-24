import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/data/services/backend_api_client.dart';
import 'package:new_asset_management_app/data/services/backend_asset_api.dart';

void main() {
  group('BackendAssetApi', () {
    late _FakeBackendApiClient client;
    late BackendAssetApi api;

    setUp(() {
      client = _FakeBackendApiClient();
      api = BackendAssetApi(client);
    });

    test('lists persons with the supplied access token', () async {
      client.nextJson = [
        {
          'id': 'person-1',
          'name': 'Alice',
          'enabled': true,
          'version': 1,
        }
      ];

      final persons = await api.listPersons('access-token');

      expect(client.requests.single, ('GET', '/persons', null, 'access-token'));
      expect(persons.single.id, 'person-1');
      expect(persons.single.name, 'Alice');
    });

    test('updates and deletes persons with optimistic versions', () async {
      client.nextJson = {
        'id': 'person-1',
        'name': 'Bob',
        'enabled': false,
        'version': 2,
      };

      final person = await api.updatePerson(
        'access-token',
        personId: 'person-1',
        input: const BackendPersonUpdate(
          version: 1,
          name: 'Bob',
          enabled: false,
        ),
      );
      await api.deletePerson('access-token', 'person-1');

      expect(client.requests[0].$1, 'PATCH');
      expect(client.requests[0].$2, '/persons/person-1');
      expect(client.requests[0].$3, {
        'version': 1,
        'name': 'Bob',
        'enabled': false,
      });
      expect(client.requests[0].$4, 'access-token');
      expect(client.requests[1],
          ('DELETE', '/persons/person-1', null, 'access-token'));
      expect(person.version, 2);
      expect(person.enabled, isFalse);
    });

    test('creates an asset using server decimal strings and date strings',
        () async {
      client.nextJson = {
        'id': 'asset-1',
        'name': '基金账户',
        'typeId': 'type-1',
        'amount': '4123.4000',
        'currency': 'CNY',
        'valuationDate': '2026-06-23T00:00:00.000Z',
        'version': 1,
      };

      final asset = await api.createAsset(
        'access-token',
        BackendAssetCreate(
          name: '基金账户',
          typeId: 'type-1',
          amount: '4123.4000',
          currency: 'CNY',
          valuationDate: DateTime.utc(2026, 6, 23),
        ),
      );

      expect(client.requests.single.$1, 'POST');
      expect(client.requests.single.$2, '/assets');
      expect(client.requests.single.$3, {
        'name': '基金账户',
        'typeId': 'type-1',
        'amount': '4123.4000',
        'currency': 'CNY',
        'valuationDate': '2026-06-23',
      });
      expect(asset.id, 'asset-1');
      expect(asset.amount, '4123.4000');
    });

    test('creates a holding under a server asset id', () async {
      client.nextJson = {
        'id': 'holding-1',
        'assetId': 'asset-1',
        'name': '沪深300ETF',
        'price': '4.1234',
        'quantity': '1000.00000000',
        'version': 1,
      };

      final holding = await api.createHolding(
        'access-token',
        assetId: 'asset-1',
        input: const BackendHoldingCreate(
          name: '沪深300ETF',
          price: '4.1234',
          quantity: '1000.00000000',
        ),
      );

      expect(client.requests.single.$2, '/assets/asset-1/holdings');
      expect(holding.id, 'holding-1');
      expect(holding.quantity, '1000.00000000');
    });

    test('updates and deletes server resources with optimistic versions',
        () async {
      client.nextJson = {
        'id': 'asset-1',
        'name': '基金账户',
        'typeId': 'type-1',
        'amount': '5000.0000',
        'currency': 'CNY',
        'valuationDate': '2026-06-23T00:00:00.000Z',
        'version': 2,
      };

      await api.updateAsset(
        'access-token',
        assetId: 'asset-1',
        input: const BackendAssetUpdate(version: 1, amount: '5000.0000'),
      );
      await api.deleteAsset('access-token', 'asset-1');

      expect(client.requests[0].$1, 'PATCH');
      expect(client.requests[0].$2, '/assets/asset-1');
      expect(client.requests[0].$3, {
        'version': 1,
        'amount': '5000.0000',
      });
      expect(client.requests[0].$4, 'access-token');
      expect(client.requests[1],
          ('DELETE', '/assets/asset-1', null, 'access-token'));
    });
  });
}

class _FakeBackendApiClient implements BackendApiClient {
  Object? nextJson;
  final List<(String, String, Map<String, Object?>?, String?)> requests = [];

  @override
  Future<Object?> getJson(String path, {String? accessToken}) async {
    requests.add(('GET', path, null, accessToken));
    return nextJson;
  }

  @override
  Future<Object?> postJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  }) async {
    requests.add(('POST', path, body, accessToken));
    return nextJson;
  }

  @override
  Future<Object?> patchJson(
    String path, {
    Map<String, Object?>? body,
    String? accessToken,
  }) async {
    requests.add(('PATCH', path, body, accessToken));
    return nextJson;
  }

  @override
  Future<void> delete(String path, {String? accessToken}) async {
    requests.add(('DELETE', path, null, accessToken));
  }
}
