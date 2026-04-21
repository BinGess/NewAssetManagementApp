import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/person.dart' as model;

class PersonRepository {
  final AppDatabase _db;

  PersonRepository(this._db);

  Stream<List<model.Person>> watchAll() {
    return (_db.select(_db.persons)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<model.Person>> getAll() async {
    final rows = await (_db.select(_db.persons)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<int> insert(String name) {
    return _db.into(_db.persons).insert(PersonsCompanion(
          name: Value(name),
        ));
  }

  Future<void> update(model.Person person) async {
    await (_db.update(_db.persons)..where((t) => t.id.equals(person.id)))
        .write(PersonsCompanion(
          name: Value(person.name),
          enabled: Value(person.enabled),
          updatedAt: Value(DateTime.now()),
        ));
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.persons)..where((t) => t.id.equals(id))).go();
  }

  model.Person _fromRow(Person row) => model.Person(
        id: row.id,
        name: row.name,
        enabled: row.enabled,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
}
