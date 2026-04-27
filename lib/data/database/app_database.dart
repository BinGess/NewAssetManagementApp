import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/asset_types_table.dart';
import 'tables/liability_types_table.dart';
import 'tables/assets_table.dart';
import 'tables/liabilities_table.dart';
import 'tables/asset_holdings_table.dart';
import 'tables/asset_changes_table.dart';
import 'tables/persons_table.dart';
import 'tables/expenses_table.dart';
import 'tables/snapshots_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  AssetTypes,
  LiabilityTypes,
  Assets,
  Liabilities,
  AssetHoldings,
  AssetChanges,
  Persons,
  Expenses,
  Snapshots,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for testing with an in-memory database
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultData();
        },
        onUpgrade: (m, from, to) async {
          // v1 → v2: add personId column to assets and liabilities
          if (from < 2) {
            await m.addColumn(assets, assets.personId);
            await m.addColumn(liabilities, liabilities.personId);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _seedDefaultData() async {
    await transaction(() async {
      final assetTypeLabels = [
        ('AT1', '现金及活期'),
        ('AT2', '定期存款'),
        ('AT3', '货币基金'),
        ('AT4', '股票'),
        ('AT5', '基金'),
        ('AT6', '债券'),
        ('AT7', '房产'),
        ('AT8', '其他'),
      ];
      for (var i = 0; i < assetTypeLabels.length; i++) {
        await into(assetTypes).insert(AssetTypesCompanion(
          code: Value(assetTypeLabels[i].$1),
          label: Value(assetTypeLabels[i].$2),
          sortOrder: Value(i),
        ));
      }

      final liabilityTypeLabels = [
        ('LT1', '房贷'),
        ('LT2', '车贷'),
        ('LT3', '信用卡'),
        ('LT4', '个人贷款'),
        ('LT5', '其他'),
      ];
      for (var i = 0; i < liabilityTypeLabels.length; i++) {
        await into(liabilityTypes).insert(LiabilityTypesCompanion(
          code: Value(liabilityTypeLabels[i].$1),
          label: Value(liabilityTypeLabels[i].$2),
          sortOrder: Value(i),
        ));
      }
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'asset_management');
}
