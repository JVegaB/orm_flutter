
enum DatabaseType { text, integer }

/// The definition of a field in a row from a SQL table.
class FieldType {
  final String name;
  final DatabaseType type;

  const FieldType(this.name, this.type);
}

/// The value of a field in a row from a SQL table.
class FieldValue {
  final FieldType valueType;
  final dynamic value;

  const FieldValue (this.value, this.valueType);

  clone () => FieldValue (value, valueType);

  String get databaseValue {
    switch (valueType.type) {
      case DatabaseType.integer:
        return '$value';
      case DatabaseType.text:
        return '"$value"';
    }
  }
}
/// Raw field intended for creating new records
class RawField {
  final String name;
  final dynamic value;

  RawField(this.name, this.value);
}

/// A record or registry in a SQL table.
class Record {
  final Set<FieldValue> fields;

  Record(this.fields);

  dynamic operator [] (String key) {
    for (final field in fields) {
      if (field.valueType.name == key) {
        return field.value;
      }
    }
  }
}

/// The definition of a SQL table.
class TableDefinition {
  final Set<FieldType> fields;

  const TableDefinition(this.fields);

  FieldType? contains (RawField rawField) {
    for (final field in fields) {
      if (field.name == rawField.name) {
        return field;
      }
    }
  }
}

abstract class Model {
  final List<Record> _records = [];
  abstract final TableDefinition fields;
  abstract final String tableName;

  List<dynamic> operator [] (String key) {
    final values = <dynamic> [];
    for (final record in _records) {
        values.add(record[key]);
    }
    return values;
  }

  Model ([ List<Set<RawField>>? newRecords ]) {
    newRecords ??= [];
    for (final Set<RawField> rawFields in newRecords) {
      final Set<FieldValue> newRecordFields = {};
      for (final RawField rawField in rawFields.toList()) {
        final validField = fields.contains(rawField);
        if (validField == null) {
          continue;
        }
        newRecordFields.add(FieldValue(rawField.value, validField));
      }
      final record = Record(newRecordFields);
      _records.add(record);
    }
  }

  Model generateModel (List<Set<RawField>> listValues);

  @override
  String toString() {
    return super.toString() + _records.toString();
  }

}

