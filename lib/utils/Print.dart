import 'package:flibrary_plugin/utils/utils.dart' show PathUtil;

class Print {
  static const VERBOSE = 2;
  static const DEBUG = 3;
  static const INFO = 4;
  static const WARN = 5;
  static const ERROR = 6;
  static const ASSERT = 7;

  static Print _instance = Print._internal();
  static bool debug = true;
  static bool fileDebug = true;
  static int level = VERBOSE;

  factory Print() {
    return _instance;
  }

  Print._internal();

  void printNative(Object object, {int level: VERBOSE}) {
    if (Print.level > level) {
      return;
    }

    if (debug) {
      print(object);
    }
    if (fileDebug) {
      PathUtil.writeLog("$object\n",
          directory: level == ASSERT ? "exceptions" : "flutterLogs");
    }
  }
}
