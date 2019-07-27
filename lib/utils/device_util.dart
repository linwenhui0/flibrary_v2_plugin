import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:flibrary_plugin/plugins/FLibraryPlugin.dart';

import 'Print.dart';

class DeviceUtil {
  DeviceUtil._();

  static Future<String> getMode() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.utsname.machine;
    }
  }

  static Future<String> getPhoneType() async {
    int phoneType = await FLibraryPlugin.getPhoneType;
    Print().printNative("getPhoneType ($phoneType)");
    if (phoneType == -1) {
      return "";
    }
    if (phoneType == 0) {
      return "2";
    }
    return "1";
  }

  static Future<String> getSystemVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.systemVersion;
    }
    return "";
  }

  static Future<String> getDeviceLanguage() async {
    return await FLibraryPlugin.getLanguage;
  }

  static Future<String> getSerial() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }else if(Platform.isIOS){
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    }
  }

}
