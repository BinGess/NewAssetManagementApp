import 'package:drift/drift.dart';

class AssetTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 50)();
  TextColumn get label => text().withLength(min: 1, max: 100)();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get order => integer().withDefault(const Constant(0))();
}
