import 'dart:io';

import 'package:flibrary_plugin/utils/Print.dart';
import 'package:flibrary_plugin/utils/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    show getExternalStorageDirectory, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'package:flibrary_plugin/annotation/database/annotation.dart';

class DatabaseManager {
  static Database _database;
  static DatabaseManager _instance = DatabaseManager._();
  String _name;
  int _version;
  List<DatabaseTable> _databaseTables;
  Map<String, Dao> _daoMap;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._();

  init(String name, int version, List<DatabaseTable> databaseTables) {
    this._name = name;
    this._version = version;
    this._databaseTables = databaseTables;
    _daoMap = Map();
  }

  _init() async {
    String dbPath = await _createNewDb(_name, externalStorage: true);
    Print().printNative("数据库所在位置 : $dbPath");
    _database = await openDatabase(dbPath, version: _version,
        onCreate: (Database db, int version) {
      _databaseTables.forEach((databaseTable) async =>
          await db.execute(databaseTable.createTable()));
    });
  }

  /// TODO 创建数据库
  Future<String> _createNewDb(String dbName,
      {bool externalStorage = false, bool existDeleteDB = false}) async {
    Directory documentDirectory;
    if (externalStorage && await PathUtil.haveExternalStorage()) {
      documentDirectory = await getExternalStorageDirectory();
    } else {
      documentDirectory = await getApplicationDocumentsDirectory();
    }
    String path = join(documentDirectory.path, dbName);
    if (await new Directory(dirname(path)).exists()) {
      if (existDeleteDB) {
        await deleteDatabase(path);
      }
    } else {
      try {
        await new Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        Print().printNative("exception : ${e.toString()}");
      }
    }
    return path;
  }

  Future<Database> getDatabase() async {
    if (_database == null) {
      await _init();
    }
    return _database;
  }

  destroy() {
    if (_database != null) {
      _database.close();
      _database = null;
    }

    if (_databaseTables != null) {
      _databaseTables.clear();
      _databaseTables = null;
    }

    if (_daoMap != null) {
      _daoMap.clear();
      _daoMap = null;
    }
  }

  Dao getDao(String tableName) {
    Print().printNative("getDao tableName($tableName)");
    Dao dao;
    if (_daoMap.containsKey(tableName)) {
      Print().printNative("getDao cache");
      dao = _daoMap[tableName];
    } else {
      int index = _databaseTables
          .indexWhere((databaseTable) => databaseTable.tableName == tableName);
      Print().printNative("getDao index($index)");
      if (index > -1) {
        DatabaseTable databaseTable = _databaseTables[index];
        dao = Dao._(databaseTable, this);
        _daoMap[tableName] = dao;
      }
    }
    return dao;
  }
}

class Dao {
  final DatabaseTable _databaseTable;
  final DatabaseManager _databaseManager;

  Dao._(this._databaseTable, this._databaseManager);

  Future<List> query({String sql}) async {
    Database db = await _databaseManager.getDatabase();
    if (sql == null || sql.isEmpty) {
      sql = _databaseTable.querySQL();
    }
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    if (maps != null && maps.isNotEmpty) {
      List results = List();
      maps.forEach((map) => results.add(_databaseTable.createBean(map)));
      return results;
    }
    return null;
  }

  Future<bool> insert({Object object, String sql}) async {
    Database db = await _databaseManager.getDatabase();
    bool insertResult = true;
    if (sql == null || sql.isEmpty) {
      if (object != null) {
        sql = _databaseTable.insertSQL(object);
      }
    }
    int result = -1;
    if (sql != null && sql.isNotEmpty) {
      result = await db.rawInsert(sql);
      if (result == -1) {
        insertResult = false;
      }
    } else {
      insertResult = false;
    }

    return insertResult;
  }

  Future<bool> update({Object object, String sql}) async {
    Database db = await _databaseManager.getDatabase();
    bool updateResult = true;
    if (sql == null || sql.isEmpty) {
      if (object != null) {
        sql = _databaseTable.updateSQL(object);
      }
    }
    Print().printNative("update updateSql($sql)");
    if (sql != null && sql.isNotEmpty) {
      int updateInt = await db.rawUpdate(sql);
      Print().printNative("update updateInt($updateInt)");
      if (updateInt == -1) {
        updateResult = false;
      }
    } else {
      updateResult = false;
    }
    return updateResult;
  }

  Future<bool> delete({Object object, String sql}) async {
    Database db = await _databaseManager.getDatabase();
    bool deleteResult = true;
    if (sql == null || sql.isEmpty) {
      if (object != null) {
        sql = _databaseTable.deleteSQL(object);
      }
    }
    if (sql != null && sql.isNotEmpty) {
      int deleteInt = await db.rawDelete(sql);
      Print().printNative("delete deleteInt($deleteInt)");
      if (deleteInt == -1) {
        deleteResult = false;
      }
    } else {
      deleteResult = false;
    }
    return deleteResult;
  }
}
