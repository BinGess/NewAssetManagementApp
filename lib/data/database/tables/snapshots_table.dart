import 'package:drift/drift.dart';

class Snapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get totalAssets => real()();
  RealColumn get totalLiabilities => real()();
  RealColumn get netWorth => real()();
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
