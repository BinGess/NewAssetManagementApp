import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/liability.dart' as model;

class LiabilityRepository {
  final AppDatabase _db;

  LiabilityRepository(this._db);

  Stream<List<model.Liability>> watchAll() {
    return (_db.select(_db.liabilities)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<model.Liability>> getAll() async {
    final rows = await (_db.select(_db.liabilities)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<int> insert({
    required String name,
    required int typeId,
    required double amount,
    required String currency,
    double? interestRate,
    DateTime? dueDate,
    String? notes,
    int? personId,
  }) {
    return _db.into(_db.liabilities).insert(LiabilitiesCompanion(
          name: Value(name),
          typeId: Value(typeId),
          amount: Value(amount),
          currency: Value(currency),
          interestRate: Value(interestRate),
          dueDate: Value(dueDate),
          notes: Value(notes),
          personId: Value(personId),
        ));
  }

  Future<void> update(model.Liability updated) async {
    await (_db.update(_db.liabilities)
          ..where((t) => t.id.equals(updated.id)))
        .write(LiabilitiesCompanion(
          name: Value(updated.name),
          typeId: Value(updated.typeId),
          amount: Value(updated.amount),
          currency: Value(updated.currency),
          interestRate: Value(updated.interestRate),
          dueDate: Value(updated.dueDate),
          notes: Value(updated.notes),
          personId: Value(updated.personId),
        ));
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.liabilities)..where((t) => t.id.equals(id))).go();
  }

  model.Liability _fromRow(Liability row) => model.Liability(
        id: row.id,
        name: row.name,
        typeId: row.typeId,
        amount: row.amount,
        currency: row.currency,
        interestRate: row.interestRate,
        dueDate: row.dueDate,
        notes: row.notes,
        personId: row.personId,
      );
}
