import 'package:drift/drift.dart';
import 'asset_types_table.dart';

class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get typeId => integer().references(AssetTypes, #id)();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  DateTimeColumn get valuationDate => dateTime()();
  RealColumn get annualRate => real().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}
