import 'package:flibrary_plugin/utils/Print.dart';

enum DataType { string, int, double, bool }

/// TODO 表基本信息
abstract class DatabaseTable<T> {
  final String tableName;

  final List<DatabaseField> dbFields;

  DatabaseTable(this.tableName, this.dbFields);

  String createTable() {
    List<DatabaseField> fields = this.dbFields;
    StringBuffer sqlBuffer = StringBuffer();
    sqlBuffer.write("CREATE TABLE IF NOT EXISTS ");
    sqlBuffer.write(tableName);
    sqlBuffer.write(" (");
    final int len = fields.length - 1;
    int index = 0;
    fields.forEach((field) {
      sqlBuffer.write(field.columnName);
      switch (field.dataType) {
        case DataType.double:
          sqlBuffer.write(" REAL ");
          if (field.id) {
            sqlBuffer.write(" PRIMARY KEY ");
          }
          break;
        case DataType.int:
        case DataType.bool:
          sqlBuffer.write(" INTEGER ");
          if (field.id) {
            sqlBuffer.write(" PRIMARY KEY");
          }
          if (field.generatedId) {
            sqlBuffer.write(" AUTOINCREMENT ");
          }
          break;
        default:
          sqlBuffer.write(" TEXT ");
          if (field.id) {
            sqlBuffer.write(" PRIMARY KEY ");
          }
          break;
      }
      if (index != len) {
        sqlBuffer.write(",");
      }
      index++;
    });
    sqlBuffer.write(");");
    String sql = sqlBuffer.toString();
    Print().printNative("createTable $sql");
    return sql;
  }

  String querySQL() {
    List<DatabaseField> fields = this.dbFields;
    StringBuffer sqlBuffer = StringBuffer();
    sqlBuffer.write("SELECT ");
    final int len = fields.length - 1;
    int index = 0;
    Map<String, dynamic> fieldMap = new Map();
    fields.forEach((field) {
      fieldMap[field.columnName] = field.dataType;
      sqlBuffer.write(field.columnName);
      if (index != len) {
        sqlBuffer.write(",");
      }
      index++;
    });
    sqlBuffer.write(" FROM ");
    sqlBuffer.write(tableName);
    sqlBuffer.write(";");
    String sql = sqlBuffer.toString();
    Print().printNative("createTable $sql");
    return sql;
  }

  String insertSQL(T object) {
    List<DatabaseField> fields = this.dbFields;
    StringBuffer sqlBuffer = StringBuffer();
    // INSERT INTO 表名称 VALUES (值1, 值2,....)
    sqlBuffer.write("INSERT INTO ");
    sqlBuffer.write(tableName);
    StringBuffer keyBuffer = StringBuffer();
    StringBuffer valueBuffer = StringBuffer();
    final int len = fields.length - 1;
    int index = 0;
    fields.forEach((field) {
      dynamic value = getValue(object, field.columnName);
      if (value != null) {
        keyBuffer.write(field.columnName);
        if (field.dataType == DataType.string) {
          valueBuffer.write("'");
          valueBuffer.write(value);
          valueBuffer.write("'");
        } else if (field.dataType == DataType.bool) {
          valueBuffer.write(value ? 1 : 0);
        } else {
          valueBuffer.write(value);
        }

        if (index != len) {
          keyBuffer.write(",");
          valueBuffer.write(",");
        }
      }
      index++;
    });
    sqlBuffer.write("(");
    sqlBuffer.write(keyBuffer.toString());
    sqlBuffer.write(") ");
    sqlBuffer.write("VALUES (");
    sqlBuffer.write(valueBuffer.toString());
    sqlBuffer.write(")");
    String sql = sqlBuffer.toString();
    Print().printNative("insertSQL $sql");
    return sql;
  }

  String updateSQL(T object) {
    List<DatabaseField> fields = this.dbFields;
    StringBuffer sqlBuffer = StringBuffer();
    // INSERT INTO 表名称 VALUES (值1, 值2,....)
    sqlBuffer.write("UPDATE ");
    sqlBuffer.write(tableName);
    sqlBuffer.write(" SET ");

    final int len = fields.length - 1;
    int index = 0;
    DatabaseField masterField;
    fields.forEach((field) {
      if (field.id == true) {
        masterField = field;
      } else {
        dynamic value = getValue(object, field.columnName);
        if (value != null) {
          sqlBuffer.write(field.columnName);
          sqlBuffer.write(" = ");
          if (field.dataType == DataType.string) {
            sqlBuffer.write("'");
            sqlBuffer.write(value);
            sqlBuffer.write("'");
          } else if (field.dataType == DataType.bool) {
            sqlBuffer.write(value ? 1 : 0);
          } else {
            sqlBuffer.write(value);
          }
          if (index != len) {
            sqlBuffer.write(", ");
          }
        }
      }
      index++;
    });
    sqlBuffer.write(" WHERE ");
    if (masterField != null) {
      dynamic value = getValue(object, masterField.columnName);
      if (value != null) {
        sqlBuffer.write(masterField.columnName);
        sqlBuffer.write(" = ");
        if (masterField.dataType == DataType.string) {
          sqlBuffer.write("'");
          sqlBuffer.write(value);
          sqlBuffer.write("'");
        } else {
          sqlBuffer.write(value);
        }
        sqlBuffer.write(";");
        String sql = sqlBuffer.toString();
        Print().printNative("updateSQL $sql");
        return sql;
      }
    }

    return null;
  }

  String deleteSQL(T object) {
    List<DatabaseField> fields = this.dbFields;
    StringBuffer sqlBuffer = StringBuffer();
    // INSERT INTO 表名称 VALUES (值1, 值2,....)
    sqlBuffer.write("DELETE FROM ");
    sqlBuffer.write(tableName);
    sqlBuffer.write(" WHERE ");

    int index = fields.indexWhere((field) => field.id == true);
    if (index != -1) {
      DatabaseField databaseField = fields[index];
      sqlBuffer.write(databaseField.columnName);
      sqlBuffer.write(" = ");
      dynamic value = getValue(object, databaseField.columnName);
      if (databaseField.dataType == DataType.string) {
        sqlBuffer.write("'");
        sqlBuffer.write(value);
        sqlBuffer.write("'");
      } else if (databaseField.dataType == DataType.bool) {
        sqlBuffer.write(value ? 1 : 0);
      } else {
        sqlBuffer.write(value);
      }
      String sql = sqlBuffer.toString();
      Print().printNative("deleteSQL $sql");
      return sql;
    }
    return null;
  }

  T createBean(Map<String, dynamic> map);

  getValue(T object, String key);

  @override
  String toString() {
    return '{"tableName":$tableName}';
  }
}

/// TODO 表字体基本信息
class DatabaseField {
  final String columnName;
  final DataType dataType;
  final bool generatedId;
  final bool id;

  const DatabaseField(this.columnName,
      {this.dataType: DataType.string,
      this.generatedId: false,
      this.id: false});

  @override
  String toString() {
    return '{"columnName":$columnName,"dataType":$dataType,"generatedId":$generatedId,"id":$id}';
  }
}
