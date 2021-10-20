
import 'model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Pool {
  static late final Database database;
  static final Map <String, Model> registry = {};

  static Future <void> setDatabase (name) async {
    Pool.database = await openDatabase(
      join(await getDatabasesPath(), '$name.db')
    );
  }

  static Future <void> initialize () async {
    for (final Model model in List.from(registry.values)) {
      final fields = model.fields.fields.fold(
        'id INTEGER PRIMARY KEY',
        (String acm, FieldType curr) {
          return '$acm, ' + curr.name + ' ' + getDBTypeName(curr.type);
        },
      );
      final table = model.tableName;
      final query = 'CREATE TABLE IF NOT EXISTS $table ($fields);';
      await database.execute(query);
    }
  }

  static String getDBTypeName (DatabaseType type) {
    switch (type) {
      case DatabaseType.integer:
        return 'INTEGER';
      case DatabaseType.text:
        return 'TEXT';
    }
  }
}
