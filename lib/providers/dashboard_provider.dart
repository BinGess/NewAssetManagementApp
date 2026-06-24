import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/dashboard_summary.dart';
import '../data/models/enums.dart';
import '../data/services/backend_asset_api.dart';
import 'backend_data_providers.dart';

final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final assetsAsync = ref.watch(backendAssetsProvider);
  final liabilitiesAsync = ref.watch(backendLiabilitiesProvider);
  final assetTypesAsync = ref.watch(backendAssetTypesProvider);
  final liabilityTypesAsync = ref.watch(backendLiabilityTypesProvider);
  final expensesAsync = ref.watch(backendExpensesProvider);

  if (assetsAsync.isLoading ||
      liabilitiesAsync.isLoading ||
      assetTypesAsync.isLoading ||
      liabilityTypesAsync.isLoading ||
      expensesAsync.isLoading) {
    return const AsyncValue.loading();
  }

  final firstError = [
    assetsAsync,
    liabilitiesAsync,
    assetTypesAsync,
    liabilityTypesAsync,
    expensesAsync,
  ].where((v) => v.hasError).firstOrNull;
  if (firstError != null) {
    return AsyncValue.error(firstError.error!, firstError.stackTrace!);
  }

  return AsyncValue.data(buildBackendDashboardSummary(
    assets: assetsAsync.requireValue,
    liabilities: liabilitiesAsync.requireValue,
    assetTypes: assetTypesAsync.requireValue,
    liabilityTypes: liabilityTypesAsync.requireValue,
    expenses: expensesAsync.requireValue,
  ));
});

DashboardSummary buildBackendDashboardSummary({
  required List<BackendAsset> assets,
  required List<BackendLiability> liabilities,
  required List<BackendType> assetTypes,
  required List<BackendType> liabilityTypes,
  required List<BackendExpense> expenses,
}) {
  final totalAssets = assets.fold(0.0, (sum, a) => sum + _money(a.amount));
  final totalLiabilities =
      liabilities.fold(0.0, (sum, l) => sum + _money(l.amount));
  final monthlyExpenses =
      expenses.fold(0.0, (sum, e) => sum + _monthlyExpense(e));

  final assetsByType = <String, double>{};
  for (final asset in assets) {
    assetsByType[asset.typeId] =
        (assetsByType[asset.typeId] ?? 0) + _money(asset.amount);
  }

  final liabilitiesByType = <String, double>{};
  for (final liability in liabilities) {
    liabilitiesByType[liability.typeId] =
        (liabilitiesByType[liability.typeId] ?? 0) + _money(liability.amount);
  }

  final assetTypeTotals = assetTypes
      .where((t) => assetsByType.containsKey(t.id))
      .map((t) =>
          TypeTotal(typeId: t.id, label: t.label, total: assetsByType[t.id]!))
      .toList();

  final liabilityTypeTotals = liabilityTypes
      .where((t) => liabilitiesByType.containsKey(t.id))
      .map((t) => TypeTotal(
          typeId: t.id, label: t.label, total: liabilitiesByType[t.id]!))
      .toList();

  return DashboardSummary(
    totalAssets: totalAssets,
    totalLiabilities: totalLiabilities,
    netWorth: totalAssets - totalLiabilities,
    monthlyExpenses: monthlyExpenses,
    assetsByType: assetTypeTotals,
    liabilitiesByType: liabilityTypeTotals,
  );
}

double _money(String value) => double.tryParse(value) ?? 0;

double _monthlyExpense(BackendExpense expense) {
  final amount = _money(expense.amount);
  return switch (_cycleFromServer(expense.cycle)) {
    ExpenseCycle.daily => amount * 30,
    ExpenseCycle.weekly => amount * (52 / 12),
    ExpenseCycle.monthly => amount,
    ExpenseCycle.yearly => amount / 12,
  };
}

ExpenseCycle _cycleFromServer(String value) {
  return switch (value) {
    'DAILY' => ExpenseCycle.daily,
    'WEEKLY' => ExpenseCycle.weekly,
    'YEARLY' => ExpenseCycle.yearly,
    _ => ExpenseCycle.monthly,
  };
}
