import 'package:drift/drift.dart';
import 'assets_table.dart';

class AssetChanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get assetId => integer().references(Assets, #id)();
  RealColumn get beforeAmount => real()();
  RealColumn get afterAmount => real()();
  RealColumn get difference => real()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get notes => text().nullable()();
}
