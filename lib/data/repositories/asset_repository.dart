import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/asset.dart' as asset_model;
import '../models/asset_change.dart' as change_model;
import '../models/asset_holding.dart' as holding_model;

class AssetRepository {
  final AppDatabase _db;

  AssetRepository(this._db);

  Stream<List<asset_model.Asset>> watchAll() {
    return (_db.select(_db.assets)
          ..orderBy([(t) => OrderingTerm.desc(t.valuationDate)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<asset_model.Asset>> getAll() async {
    final rows = await (_db.select(_db.assets)
          ..orderBy([(t) => OrderingTerm.desc(t.valuationDate)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<asset_model.Asset?> getById(int id) async {
    final row = await (_db.select(_db.assets)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<int> insert({
    required String name,
    required int typeId,
    required double amount,
    required String currency,
    required DateTime valuationDate,
    double? annualRate,
    DateTime? startDate,
    String? notes,
    int? personId,
  }) {
    return _db.into(_db.assets).insert(AssetsCompanion(
          name: Value(name),
          typeId: Value(typeId),
          amount: Value(amount),
          currency: Value(currency),
          valuationDate: Value(valuationDate),
          annualRate: Value(annualRate),
          startDate: Value(startDate),
          notes: Value(notes),
          personId: Value(personId),
        ));
  }

  /// Updates an asset and records a change entry if the amount changed.
  /// Runs inside a single transaction for atomicity.
  Future<void> updateWithChangeTracking(asset_model.Asset updated,
      {String? changeNotes}) async {
    await _db.transaction(() async {
      final old = await getById(updated.id);
      if (old != null && old.amount != updated.amount) {
        await _db.into(_db.assetChanges).insert(AssetChangesCompanion(
              assetId: Value(updated.id),
              beforeAmount: Value(old.amount),
              afterAmount: Value(updated.amount),
              notes: Value(changeNotes),
            ));
      }
      await (_db.update(_db.assets)..where((t) => t.id.equals(updated.id)))
          .write(AssetsCompanion(
            name: Value(updated.name),
            typeId: Value(updated.typeId),
            amount: Value(updated.amount),
            currency: Value(updated.currency),
            valuationDate: Value(updated.valuationDate),
            annualRate: Value(updated.annualRate),
            startDate: Value(updated.startDate),
            notes: Value(updated.notes),
            personId: Value(updated.personId),
          ));
    });
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.assets)..where((t) => t.id.equals(id))).go();
  }

  // --- Holdings ---

  Stream<List<holding_model.AssetHolding>> watchHoldings(int assetId) {
    return (_db.select(_db.assetHoldings)
          ..where((t) => t.assetId.equals(assetId)))
        .watch()
        .map((rows) => rows.map(_holdingFromRow).toList());
  }

  Future<int> insertHolding({
    required int assetId,
    required String name,
    required double price,
    required double quantity,
    String? notes,
  }) {
    return _db.into(_db.assetHoldings).insert(AssetHoldingsCompanion(
          assetId: Value(assetId),
          name: Value(name),
          price: Value(price),
          quantity: Value(quantity),
          notes: Value(notes),
        ));
  }

  Future<bool> updateHolding(holding_model.AssetHolding holding) {
    return _db.update(_db.assetHoldings).replace(AssetHoldingsCompanion(
          id: Value(holding.id),
          assetId: Value(holding.assetId),
          name: Value(holding.name),
          price: Value(holding.price),
          quantity: Value(holding.quantity),
          notes: Value(holding.notes),
        ));
  }

  Future<int> deleteHolding(int holdingId) {
    return (_db.delete(_db.assetHoldings)
          ..where((t) => t.id.equals(holdingId)))
        .go();
  }

  // --- Change history ---

  Stream<List<change_model.AssetChange>> watchChanges(int assetId) {
    return (_db.select(_db.assetChanges)
          ..where((t) => t.assetId.equals(assetId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_changeFromRow).toList());
  }

  asset_model.Asset _fromRow(Asset row) => asset_model.Asset(
        id: row.id,
        name: row.name,
        typeId: row.typeId,
        amount: row.amount,
        currency: row.currency,
        valuationDate: row.valuationDate,
        annualRate: row.annualRate,
        startDate: row.startDate,
        notes: row.notes,
        personId: row.personId,
      );

  change_model.AssetChange _changeFromRow(AssetChange row) =>
      change_model.AssetChange(
        id: row.id,
        assetId: row.assetId,
        beforeAmount: row.beforeAmount,
        afterAmount: row.afterAmount,
        createdAt: row.createdAt,
        notes: row.notes,
      );

  holding_model.AssetHolding _holdingFromRow(AssetHolding row) =>
      holding_model.AssetHolding(
        id: row.id,
        assetId: row.assetId,
        name: row.name,
        price: row.price,
        quantity: row.quantity,
        notes: row.notes,
      );
}
