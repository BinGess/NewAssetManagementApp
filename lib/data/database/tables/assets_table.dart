import 'package:drift/drift.dart';
import 'asset_types_table.dart';
import 'persons_table.dart';

class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get typeId => integer().references(AssetTypes, #id,
      onDelete: KeyAction.restrict)();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  DateTimeColumn get valuationDate => dateTime()();
  RealColumn get annualRate => real().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  // v2: person attribution (nullable — assets without a specific owner)
  IntColumn get personId => integer()
      .nullable()
      .references(Persons, #id, onDelete: KeyAction.setNull)();
}
