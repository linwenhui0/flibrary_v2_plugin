import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_permissions/flutter_permissions.dart';
import 'package:flutter_utils/util/device_util.dart';

class FLibraryPlugin {
  FLibraryPlugin._();

  static const MethodChannel _channel = const MethodChannel('flibrary_plugin');

  static Future<int> get getScreenWidth async {
    final int result = await _channel.invokeMethod("getScreenWidth");
    return result;
  }

  static Future<int> get getScreenHeight async {
    final int result = await _channel.invokeMethod("getScreenHeight");
    return result;
  }

  static Future<double> get getScreenRatio async {
    final double result = await _channel.invokeMethod("getScreenRatio");
    return result;
  }

  static Future<double> get getTextRatio async {
    final double result = await _channel.invokeMethod("getTextRatio");
    return result;
  }

  static Future<String> getRouteWifiMac() async {
    if (await FlutterPermissions.requestPermission(
            Permission.AccessFineLocation) ==
        PermissionStatus.authorized) {
      return await _channel.invokeMethod("getRouteMacAddress");
    }
    return "";
  }

  static Future<String> getMacAddress() async {
    if (await FlutterPermissions.requestPermission(
        Permission.ReadPhoneState) ==
        PermissionStatus.authorized) {
      return await _channel.invokeMethod("getMacAddress");
    }
    return "";
  }

  static Future<String> get getImei async {
    if (await FlutterPermissions.requestPermission(Permission.ReadPhoneState) ==
        PermissionStatus.authorized) {
      if (Platform.isAndroid) {
        return await _channel.invokeMethod("getImei");
      }else if(Platform.isIOS){
        return DeviceUtil.getSerial();
      }
    }
    return "";
  }

  static Future<bool> isRoot() async {
    return await _channel.invokeMethod("isRoot");
  }

  static Future<bool> isVpn() async {
    return await _channel.invokeMethod("isVpn");
  }

  static Future<String> getIDFA() async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod("getIDFA");
    }
    return "";
  }

  static Future<String> getIDFV() async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod("getIDFV");
    }
    return "";
  }

  // 代理ip
  static Future<String> getProxyHost() async {
    if(Platform.isAndroid){
      return _channel.invokeMethod("getProxyHost");
    }
    return "";
  }

  // 代理端口
  static Future<String> getProxyPort() async {
    if(Platform.isAndroid){
      return _channel.invokeMethod("getProxyPort");
    }
    return "";
  }

  // 判断是否为release版本
  static Future<bool> isRelease() async {
    return _channel.invokeMethod("isRelease");
  }
}
