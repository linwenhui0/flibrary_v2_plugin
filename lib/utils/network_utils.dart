import 'package:connectivity/connectivity.dart';
import 'package:flibrary_plugin/plugins/FLibraryPlugin.dart';
import 'package:flutter_permissions/flutter_permissions.dart';

class NetworkUtil {
  NetworkUtil._();

  static Future<bool> isConnected() async {
    if (await FlutterPermissions.requestPermission(
            Permission.AccessNetworkState) ==
        PermissionStatus.authorized) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;
    }
    return false;
  }

  static Future<String> getCurrentNetworkType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // 网络类型为移动网络
      return FLibraryPlugin.getCurrentNetworkType;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // 网络类型为WIFI
      return "Wi-Fi";
    }
    return "未知";
  }

  static Future<String> getWifiMac() async {
    if (await FlutterPermissions.requestPermission(
            Permission.AccessFineLocation) ==
        PermissionStatus.authorized) {
      return await Connectivity().getWifiBSSID();
    }
    return "";
  }
}
