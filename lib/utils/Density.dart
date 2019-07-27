import 'dart:math' as Math;
import 'dart:ui' show window;

import 'package:flibrary_plugin/utils/Print.dart';
import 'package:flutter/material.dart';

class Density {
  static Density _instance = Density._internal();

  /// TODO 是否需要重新计算。true不需要重新计算，否则需要进行重新计算
  bool _needCal;
  double _screenWidth = 0;
  double _screenHeight = 0;
  double _ratio = 0.0;
  double _wRatio = 0.0;
  double _hRatio = 0.0;

  static int _designWidth = 720;
  static int _designHeight = 1280;
  Map<double, double> _result, _wResult, _hResult;

  factory Density() {
    return _instance;
  }

  Density._internal() {
    _result = {};
    _wResult = {};
    _hResult = {};
  }

  void destroy() {
    _result?.clear();
    _result = null;
    _wResult?.clear();
    _wResult = null;
    _hResult?.clear();
    _hResult = null;
    _ratio = 0.0;
    _wRatio = 0.0;
    _hRatio = 0.0;
  }

  void init({int designWidth = 720, int designHeight = 1280}) async {
//    _mediaQuery = MediaQuery.of(context);

    _designWidth = designWidth;
    _designHeight = designHeight;
    _initScreenSize();
    Print().printNative(
        "_screenWidth($_screenWidth) _screenHeight($_screenHeight)");
  }

  /// 初始化屏幕尺寸
  void _initScreenSize() {
    MediaQueryData _mediaQuery = MediaQueryData.fromWindow(window);
    _screenWidth = _mediaQuery?.size?.width;
    _needCal = true;
    if (_screenWidth == null || _screenWidth == 0.0) {
      Size physicalSize = window.physicalSize;
      double ratio = window.devicePixelRatio;
      if (physicalSize != null && ratio != null && ratio > 0) {
        _screenWidth = physicalSize.width / ratio;
      } else {
        _screenWidth = _designWidth.toDouble();
        _needCal = false;
      }
    }
    _screenHeight = _mediaQuery?.size?.height;
    if (_screenHeight == null || _screenHeight == 0.0) {
      Size physicalSize = window.physicalSize;
      double ratio = window.devicePixelRatio;
      if (physicalSize != null && ratio != null && ratio > 0) {
        _screenHeight = physicalSize.height / ratio;
      } else {
        _screenHeight = _designHeight.toDouble();
        _needCal = false;
      }
    }
    Print().printNative("初始化屏幕尺寸 是否需要重新计算屏幕密度($_needCal) true表示不需要重新计算屏幕密度");
  }

  /// TODO 是否需要重新计算。
  /// true 需要重新计算，
  /// 否则不需要进行重新计算
  bool isNeedReCall() {
    return !(_needCal == true);
  }

  double ratio() {
    if (_ratio == null || _ratio == 0.0) {
      _wRatio = wRatio();
      _hRatio = hRatio();
      Print().printNative(
          "_screenWidth($_screenWidth) _wRatio($_wRatio) _screenHeight($_screenHeight) _hRatio($_hRatio)");
      _ratio = Math.min(_wRatio, _hRatio);
    }
    return _ratio;
  }

  double wRatio() {
    if (_wRatio == null || _wRatio == 0.0 || isNeedReCall()) {
      _initScreenSize();
      _wRatio = _screenWidth / _designWidth;
    }
    return _wRatio;
  }

  double hRatio() {
    if (_hRatio == null || _hRatio == 0.0 || isNeedReCall()) {
      _initScreenSize();
      _hRatio = _screenHeight / _designHeight;
    }
    return _hRatio;
  }

  double autoPx(double px) {
    if (_result == null) {
      _result = Map();
    }
    if (isNeedReCall() && _result.containsKey(px)) {
      return _result[px];
    }
    double _px = px * ratio();
    if (!isNeedReCall()) {
      _result[px] = _px;
      return _px;
    }
    return px;
  }

  double autoWPx(double px) {
    if (_wResult == null) {
      _wResult = Map();
    }
    if (isNeedReCall() && _wResult.containsKey(px)) {
      return _wResult[px];
    }
    double _px = px * wRatio();
    if (!isNeedReCall()) {
      _wResult[px] = _px;
      return _px;
    }
    return px;
  }

  double autoHPx(double px) {
    if (_hResult == null) {
      _hResult = Map();
    }
    if (isNeedReCall() && _hResult.containsKey(px)) {
      return _hResult[px];
    }
    double _px = px * hRatio();
    if (!isNeedReCall()) {
      _hResult[px] = _px;
      return _px;
    }
    return px;
  }
}
