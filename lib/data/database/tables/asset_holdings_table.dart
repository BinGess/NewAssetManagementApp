import 'package:drift/drift.dart';
import 'assets_table.dart';

class AssetHoldings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get assetId => integer().references(Assets, #id)();
  TextColumn get name => text()();
  RealColumn get price => real()();
  RealColumn get quantity => real()();
  TextColumn get notes => text().nullable()();
}
