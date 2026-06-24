import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/backend_asset_api.dart';
import 'auth_provider.dart';

Future<String?> _accessToken(Ref ref) async {
  return (await ref.watch(authProvider.future)).accessToken;
}

final backendPersonsProvider = FutureProvider<List<BackendPerson>>((ref) async {
  final token = await _accessToken(ref);
  if (token == null) return const [];
  return ref.watch(backendAssetApiProvider).listPersons(token);
});

final backendAssetTypesProvider =
    FutureProvider<List<BackendType>>((ref) async {
  final token = await _accessToken(ref);
  if (token == null) return const [];
  return ref.watch(backendAssetApiProvider).listAssetTypes(token);
});

final backendLiabilityTypesProvider =
    FutureProvider<List<BackendType>>((ref) async {
  final token = await _accessToken(ref);
  if (token == null) return const [];
  return ref.watch(backendAssetApiProvider).listLiabilityTypes(token);
});

final backendAssetsProvider = FutureProvider<List<BackendAsset>>((ref) async {
  final token = await _accessToken(ref);
  if (token == null) return const [];
  return ref.watch(backendAssetApiProvider).listAssets(token);
});

final backendLiabilitiesProvider =
    FutureProvider<List<BackendLiability>>((ref) async {
  final token = await _accessToken(ref);
  if (token == null) return const [];
  return ref.watch(backendAssetApiProvider).listLiabilities(token);
});

final backendExpensesProvider =
    FutureProvider<List<BackendExpense>>((ref) async {
  final token = await _accessToken(ref);
  if (token == null) return const [];
  return ref.watch(backendAssetApiProvider).listExpenses(token);
});

final backendHoldingsProvider =
    FutureProvider.family<List<BackendHolding>, String>((ref, assetId) async {
  final token = await _accessToken(ref);
  if (token == null) return const [];
  return ref.watch(backendAssetApiProvider).listHoldings(
        token,
        assetId: assetId,
      );
});
