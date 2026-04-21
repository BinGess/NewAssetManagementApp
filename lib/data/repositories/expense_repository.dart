import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/enums.dart';
import '../models/expense.dart' as model;

class ExpenseRepository {
  final AppDatabase _db;

  ExpenseRepository(this._db);

  Stream<List<model.Expense>> watchAll() {
    return (_db.select(_db.expenses)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<model.Expense>> getAll() async {
    final rows = await (_db.select(_db.expenses)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<int> insert({
    required String name,
    required double amount,
    required ExpenseCycle cycle,
    required int personId,
    required DateTime date,
    String? notes,
  }) {
    return _db.into(_db.expenses).insert(ExpensesCompanion(
          name: Value(name),
          amount: Value(amount),
          cycle: Value(cycle.name),
          personId: Value(personId),
          date: Value(date),
          notes: Value(notes),
        ));
  }

  Future<void> update(model.Expense updated) async {
    await (_db.update(_db.expenses)..where((t) => t.id.equals(updated.id)))
        .write(ExpensesCompanion(
          name: Value(updated.name),
          amount: Value(updated.amount),
          cycle: Value(updated.cycle.name),
          personId: Value(updated.personId),
          date: Value(updated.date),
          notes: Value(updated.notes),
        ));
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.expenses)..where((t) => t.id.equals(id))).go();
  }

  model.Expense _fromRow(Expense row) => model.Expense(
        id: row.id,
        name: row.name,
        amount: row.amount,
        cycle: expenseCycleFromString(row.cycle),
        personId: row.personId,
        date: row.date,
        notes: row.notes,
      );
}
