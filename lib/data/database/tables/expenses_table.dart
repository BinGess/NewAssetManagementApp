import 'package:drift/drift.dart';
import 'persons_table.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  RealColumn get amount => real()();
  TextColumn get cycle => text()(); // 'daily' | 'weekly' | 'monthly' | 'yearly'
  IntColumn get personId => integer().references(Persons, #id,
      onDelete: KeyAction.restrict)();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
}
