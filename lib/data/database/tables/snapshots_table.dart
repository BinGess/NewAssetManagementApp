import 'package:drift/drift.dart';

class Snapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get totalAssets => real()();
  RealColumn get totalLiabilities => real()();
  RealColumn get netWorth => real()();
  DateTimeColumn get createdAt => dateTime()();
}
