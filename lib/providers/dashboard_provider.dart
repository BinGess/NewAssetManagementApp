import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/dashboard_summary.dart';
import 'data_providers.dart';

final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final assetsAsync = ref.watch(assetsStreamProvider);
  final liabilitiesAsync = ref.watch(liabilitiesStreamProvider);
  final assetTypesAsync = ref.watch(assetTypesStreamProvider);
  final liabilityTypesAsync = ref.watch(liabilityTypesStreamProvider);

  // If any stream is loading, the whole summary is loading
  if (assetsAsync.isLoading ||
      liabilitiesAsync.isLoading ||
      assetTypesAsync.isLoading ||
      liabilityTypesAsync.isLoading) {
    return const AsyncValue.loading();
  }

  // If any stream has an error, propagate the first error
  final firstError = [assetsAsync, liabilitiesAsync, assetTypesAsync, liabilityTypesAsync]
      .where((v) => v.hasError)
      .firstOrNull;
  if (firstError != null) {
    return AsyncValue.error(firstError.error!, firstError.stackTrace!);
  }

  final assets = assetsAsync.requireValue;
  final liabilities = liabilitiesAsync.requireValue;
  final assetTypes = assetTypesAsync.requireValue;
  final liabilityTypes = liabilityTypesAsync.requireValue;

  final totalAssets = assets.fold(0.0, (sum, a) => sum + a.amount);
  final totalLiabilities = liabilities.fold(0.0, (sum, l) => sum + l.amount);

  // Group assets by type
  final assetsByType = <int, double>{};
  for (final asset in assets) {
    assetsByType[asset.typeId] = (assetsByType[asset.typeId] ?? 0) + asset.amount;
  }

  // Group liabilities by type
  final liabilitiesByType = <int, double>{};
  for (final liability in liabilities) {
    liabilitiesByType[liability.typeId] =
        (liabilitiesByType[liability.typeId] ?? 0) + liability.amount;
  }

  final assetTypeTotals = assetTypes
      .where((t) => assetsByType.containsKey(t.id))
      .map((t) => TypeTotal(typeId: t.id, label: t.label, total: assetsByType[t.id]!))
      .toList();

  final liabilityTypeTotals = liabilityTypes
      .where((t) => liabilitiesByType.containsKey(t.id))
      .map((t) => TypeTotal(typeId: t.id, label: t.label, total: liabilitiesByType[t.id]!))
      .toList();

  return AsyncValue.data(DashboardSummary(
    totalAssets: totalAssets,
    totalLiabilities: totalLiabilities,
    netWorth: totalAssets - totalLiabilities,
    assetsByType: assetTypeTotals,
    liabilitiesByType: liabilityTypeTotals,
  ));
});
