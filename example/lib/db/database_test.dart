import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flibrary_plugin/utils/utils.dart';
import 'package:path_provider/path_provider.dart'
    show getExternalStorageDirectory, getApplicationDocumentsDirectory;
import 'dart:io';

class DatabaseTest {
  static const _VERSION = 1;
  static const _NAME = "demo.db";
  static Database _database;

  static Future<String> _createNewDb(String dbName,
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
        print(e);
      }
    }
    return path;
  }

  static _init() async {
    String dbPath = await _createNewDb(_NAME, externalStorage: true);
    print(dbPath);
    _database = await openDatabase(dbPath, version: _VERSION,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)");
    });
  }

  static insert(int id, String name, int age) async {
    await getDatabase();
    try {
      var res = await _database.rawInsert("INSERT INTO Test(id, name, age) VALUES($id, \"$name\", $age)");
      return res;
    } catch (e) {
      print(e);
    }
    return -1;
  }

  static query() async {
    await getDatabase();
    List maps = await _database.rawQuery("select id, name, age from Test");
    if(maps!=null&&maps.isNotEmpty){
      Map item = maps[0];
      print("$item ${item.runtimeType} ${item['name']} ${item['age']}");
    }
    return maps;
  }

  static getDatabase() async {
    if (_database == null) {
      await _init();
    }
    return _database;
  }

  static closeDatabase() {
    if (_database != null) {
      _database.close();
      _database = null;
    }
  }
}
