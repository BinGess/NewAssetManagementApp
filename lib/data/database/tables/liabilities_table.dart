import 'package:drift/drift.dart';
import 'liability_types_table.dart';

class Liabilities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get typeId => integer().references(LiabilityTypes, #id,
      onDelete: KeyAction.restrict)();
  RealColumn get amount => real()();
  RealColumn get interestRate => real().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  TextColumn get notes => text().nullable()();
}
