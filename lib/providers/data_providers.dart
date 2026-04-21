import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/asset_type.dart';
import '../data/models/liability_type.dart';
import '../data/models/asset.dart';
import '../data/models/asset_holding.dart';
import '../data/models/asset_change.dart';
import '../data/models/liability.dart';
import '../data/models/person.dart';
import '../data/models/expense.dart';
import '../data/models/snapshot.dart';
import 'repository_providers.dart';

// Asset Types
final assetTypesStreamProvider = StreamProvider<List<AssetType>>((ref) {
  return ref.watch(assetTypeRepositoryProvider).watchAll();
});

// Liability Types
final liabilityTypesStreamProvider = StreamProvider<List<LiabilityType>>((ref) {
  return ref.watch(liabilityTypeRepositoryProvider).watchAll();
});

// Assets
final assetsStreamProvider = StreamProvider<List<Asset>>((ref) {
  return ref.watch(assetRepositoryProvider).watchAll();
});

// Asset holdings for a specific asset
final assetHoldingsProvider = StreamProvider.family<List<AssetHolding>, int>((ref, assetId) {
  return ref.watch(assetRepositoryProvider).watchHoldings(assetId);
});

// Asset change history for a specific asset
final assetChangesProvider = StreamProvider.family<List<AssetChange>, int>((ref, assetId) {
  return ref.watch(assetRepositoryProvider).watchChanges(assetId);
});

// Liabilities
final liabilitiesStreamProvider = StreamProvider<List<Liability>>((ref) {
  return ref.watch(liabilityRepositoryProvider).watchAll();
});

// Persons
final personsStreamProvider = StreamProvider<List<Person>>((ref) {
  return ref.watch(personRepositoryProvider).watchAll();
});

// Expenses
final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  return ref.watch(expenseRepositoryProvider).watchAll();
});

// Snapshots for trend chart — parameterized by period string ('30d', '6m', '1y')
final snapshotsForPeriodProvider = StreamProvider.family<List<Snapshot>, String>((ref, period) {
  final cutoff = switch (period) {
    '30d' => DateTime.now().subtract(const Duration(days: 30)),
    '6m'  => DateTime.now().subtract(const Duration(days: 180)),
    _     => DateTime.now().subtract(const Duration(days: 365)),
  };
  return ref.watch(snapshotRepositoryProvider).watchSince(cutoff);
});
