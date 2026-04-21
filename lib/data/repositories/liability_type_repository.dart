import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/liability_type.dart' as model;

class LiabilityTypeRepository {
  final AppDatabase _db;

  LiabilityTypeRepository(this._db);

  Stream<List<model.LiabilityType>> watchAll() {
    return (_db.select(_db.liabilityTypes)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<model.LiabilityType>> getAll() async {
    final rows = await (_db.select(_db.liabilityTypes)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<int> insert(String code, String label) {
    return _db.into(_db.liabilityTypes).insert(LiabilityTypesCompanion(
          code: Value(code),
          label: Value(label),
        ));
  }

  Future<bool> update(model.LiabilityType type) {
    return _db.update(_db.liabilityTypes).replace(LiabilityTypesCompanion(
          id: Value(type.id),
          code: Value(type.code),
          label: Value(type.label),
          enabled: Value(type.enabled),
          sortOrder: Value(type.sortOrder),
        ));
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.liabilityTypes)..where((t) => t.id.equals(id))).go();
  }

  model.LiabilityType _fromRow(LiabilityType row) => model.LiabilityType(
        id: row.id,
        code: row.code,
        label: row.label,
        enabled: row.enabled,
        sortOrder: row.sortOrder,
      );
}
