import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/snapshot.dart' as model;

class SnapshotRepository {
  final AppDatabase _db;

  SnapshotRepository(this._db);

  Stream<List<model.Snapshot>> watchSince(DateTime cutoff) {
    return (_db.select(_db.snapshots)
          ..where((t) => t.createdAt.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<model.Snapshot?> getLatest() async {
    final row = await (_db.select(_db.snapshots)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<void> insert({
    required double totalAssets,
    required double totalLiabilities,
    required String currency,
  }) {
    return _db.into(_db.snapshots).insert(SnapshotsCompanion(
          totalAssets: Value(totalAssets),
          totalLiabilities: Value(totalLiabilities),
          netWorth: Value(totalAssets - totalLiabilities),
          currency: Value(currency),
        ));
  }

  model.Snapshot _fromRow(Snapshot row) => model.Snapshot(
        id: row.id,
        totalAssets: row.totalAssets,
        totalLiabilities: row.totalLiabilities,
        netWorth: row.netWorth,
        currency: row.currency,
        createdAt: row.createdAt,
      );
}
