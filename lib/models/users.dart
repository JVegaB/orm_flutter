
import 'package:flutter_application_2/orm/model.dart';


class Users extends Model {
  @override final tableName = 'users';
  @override final fields = const TableDefinition({
    FieldType('name', DatabaseType.text),
    FieldType('login', DatabaseType.text),
    FieldType('password', DatabaseType.text),
    FieldType('database', DatabaseType.text),
    FieldType('active', DatabaseType.text),
  });

  @override Model generateModel(List<Set<RawField>> listValues) => Users(listValues);

  Users([List<Set<RawField>>? values]) : super(values);
}
