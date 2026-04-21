import 'package:drift/drift.dart';
import 'assets_table.dart';

class AssetChanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get assetId => integer().references(Assets, #id,
      onDelete: KeyAction.cascade)();
  RealColumn get beforeAmount => real()();
  RealColumn get afterAmount => real()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  TextColumn get notes => text().nullable()();
}
