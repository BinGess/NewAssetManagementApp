import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/asset_type.dart' as model;

class AssetTypeRepository {
  final AppDatabase _db;

  AssetTypeRepository(this._db);

  Stream<List<model.AssetType>> watchAll() {
    return (_db.select(_db.assetTypes)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<model.AssetType>> getAll() async {
    final rows = await (_db.select(_db.assetTypes)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<int> insert(String code, String label) {
    return _db.into(_db.assetTypes).insert(AssetTypesCompanion(
          code: Value(code),
          label: Value(label),
        ));
  }

  Future<bool> update(model.AssetType type) {
    return _db.update(_db.assetTypes).replace(AssetTypesCompanion(
          id: Value(type.id),
          code: Value(type.code),
          label: Value(type.label),
          enabled: Value(type.enabled),
          sortOrder: Value(type.sortOrder),
        ));
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.assetTypes)..where((t) => t.id.equals(id))).go();
  }

  model.AssetType _fromRow(AssetType row) => model.AssetType(
        id: row.id,
        code: row.code,
        label: row.label,
        enabled: row.enabled,
        sortOrder: row.sortOrder,
      );
}
