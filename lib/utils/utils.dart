import 'dart:io';

import 'package:flibrary_plugin/plugins/FLibraryPlugin.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

///TODO 文件/文件夹操作工具类
class PathUtil {
  PathUtil._();

  static const CACHE_FILE_SIZE = 10 * 1024 * 1024;

  ///TODO 判断是否存在sd卡
  static Future<bool> haveExternalStorage() async {
    if (Platform.isAndroid) {
      return await FLibraryPlugin.haveExternalStorage;
    } else if (Platform.isWindows) {
      return false;
    }
    return false;
  }

  ///TODO 外置缓存目录
  static Future<Directory> getExternalCacheDirectory(String dir) async {
    Directory cacheDirectory;
    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;
      Directory directory = await getExternalStorageDirectory();
      cacheDirectory =
          Directory("${directory.path}/Android/data/$packageName/$dir");
    } else if (Platform.isIOS) {
      Directory directory = await getTemporaryDirectory();
      cacheDirectory = Directory("${directory.path}/$dir");
    }
    bool exist = await cacheDirectory.exists();
    if (exist == false) {
      File cacheFile = File(cacheDirectory.path);
      if (cacheFile.existsSync() == true) {
        cacheFile.deleteSync();
      }
      cacheDirectory.createSync(recursive: true);
    }
    return cacheDirectory;
  }

  ///TODO 外置日志缓存目录
  static Future<Directory> getExternalLogCacheDirectory(String dir) async {
    DateTime now = DateTime.now();
    var formatter = DateFormat("yyyy-MM-dd");
    Directory cacheDirectory;
    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;
      Directory directory = await getExternalStorageDirectory();
      cacheDirectory = Directory(
          "${directory.path}/Android/data/$packageName/$dir/${formatter.format(now)}");
    } else if (Platform.isIOS) {
      Directory directory = await getTemporaryDirectory();
      cacheDirectory =
          Directory("${directory.path}/$dir/${formatter.format(now)}");
    }
    bool exist = await cacheDirectory.exists();
    if (exist == false) {
      File cacheFile = File(cacheDirectory.path);
      if (cacheFile.existsSync() == true) {
        cacheFile.deleteSync();
      }
      cacheDirectory.createSync(recursive: true);
    }
    return cacheDirectory;
  }

  ///TODO 内部缓存目录
  static Future<Directory> getCacheDirectory(String dir) async {
    Directory cacheDirectory = await getTemporaryDirectory();
    bool exist = await cacheDirectory.exists();
    if (exist == false) {
      File cacheFile = File(cacheDirectory.path);
      if (cacheFile.existsSync() == true) {
        cacheFile.deleteSync();
      }
      cacheDirectory.createSync(recursive: true);
    }
    return cacheDirectory;
  }

  ///
  ///TODO app外部数据库目录
  static Future<Directory> getExternalDatabaseDirectory() async {
    Directory cacheDirectory;
    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;
      Directory directory = await getExternalStorageDirectory();
      cacheDirectory =
          Directory("${directory.path}/Android/data/$packageName/database");
    } else if (Platform.isIOS) {
      Directory directory = await getTemporaryDirectory();
      cacheDirectory = Directory("${directory.path}/database");
    }
    bool exist = await cacheDirectory.exists();
    if (exist == false) {
      File cacheFile = File(cacheDirectory.path);
      if (cacheFile.existsSync() == true) {
        cacheFile.deleteSync();
      }
      cacheDirectory.createSync(recursive: true);
    }
    return cacheDirectory;
  }

  ///
  ///TODO app内部数据库目录
  static Future<Directory> getDatabaseDirectory() async {
    Directory cacheDirectory;
    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;
      Directory directory = await getApplicationDocumentsDirectory();
      cacheDirectory =
          Directory("${directory.path}/Android/data/$packageName/database");
    } else if (Platform.isIOS) {
      Directory directory = await getApplicationDocumentsDirectory();
      cacheDirectory = Directory("${directory.path}/database");
    }
    bool exist = cacheDirectory.existsSync();
    if (exist == false) {
      File cacheFile = File(cacheDirectory.path);
      if (cacheFile.existsSync() == true) {
        cacheFile.deleteSync();
      }
      cacheDirectory.createSync(recursive: true);
    }
    return cacheDirectory;
  }

  ///TODO 文件写入操作
  static void writeLog(String content,
      {String directory = "flutterLogs"}) async {
    if (Platform.isAndroid) {
      if (await haveExternalStorage() == false) {
        return;
      }
    } else if (Platform.isWindows) {
      return;
    }
    Directory flutterLogDirectory =
        await getExternalLogCacheDirectory(directory);
    List<FileSystemEntity> fileSystemEntities = flutterLogDirectory.listSync();
    int index = 1;
    if (fileSystemEntities != null && fileSystemEntities.isNotEmpty) {
      index = fileSystemEntities.length;
    }

    File file = File("${flutterLogDirectory.path}/$index.txt");
    if (file.existsSync() && file.lengthSync() > CACHE_FILE_SIZE) {
      index++;
      file = File("${flutterLogDirectory.path}/$index.txt");
    }
    file.writeAsString(
        "${DateFormantUtil.getDateTime("yyyy-MM-dd HH:mm:ss.SSS")} $content",
        mode: FileMode.append);
  }
}

class DateFormantUtil {
  static String getDateTime(String pattern) {
    var formatter = DateFormat(pattern);
    return formatter.format(DateTime.now());
  }

  static DateTime parse(String pattern, String datetime) {
    var formatter = DateFormat(pattern);
    return formatter.parse(datetime);
  }
}
