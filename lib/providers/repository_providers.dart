import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/asset_type_repository.dart';
import '../data/repositories/liability_type_repository.dart';
import '../data/repositories/asset_repository.dart';
import '../data/repositories/liability_repository.dart';
import '../data/repositories/person_repository.dart';
import '../data/repositories/expense_repository.dart';
import '../data/repositories/snapshot_repository.dart';
import '../data/repositories/dashboard_service.dart';
import 'database_provider.dart';

final assetTypeRepositoryProvider = Provider<AssetTypeRepository>((ref) {
  return AssetTypeRepository(ref.watch(appDatabaseProvider));
});

final liabilityTypeRepositoryProvider = Provider<LiabilityTypeRepository>((ref) {
  return LiabilityTypeRepository(ref.watch(appDatabaseProvider));
});

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return AssetRepository(ref.watch(appDatabaseProvider));
});

final liabilityRepositoryProvider = Provider<LiabilityRepository>((ref) {
  return LiabilityRepository(ref.watch(appDatabaseProvider));
});

final personRepositoryProvider = Provider<PersonRepository>((ref) {
  return PersonRepository(ref.watch(appDatabaseProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.watch(appDatabaseProvider));
});

final snapshotRepositoryProvider = Provider<SnapshotRepository>((ref) {
  return SnapshotRepository(ref.watch(appDatabaseProvider));
});

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService(
    ref.watch(appDatabaseProvider),
    ref.watch(snapshotRepositoryProvider),
  );
});
