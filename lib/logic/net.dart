import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flibrary_plugin/plugins/FLibraryPlugin.dart';
import 'package:flutter_utils/util/print.dart';

class Request {
  Dio dio;

  String url;
  Map<String, dynamic> _headers = Map();
  Map<String, String> _params = Map();
  Map<String, MultipartFile> _files = Map();
  Map<String, String> _extra = Map();
  bool useProxy;

  Request() {
    dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    _initProxy();
  }

  _initProxy() async {
    if (useProxy == true) {
      String host = await FLibraryPlugin.getProxyHost();
      String port = await FLibraryPlugin.getProxyPort();
      if (host?.isNotEmpty == true && port?.isNotEmpty == true) {
        Print().printNative("host($host) port($port)");
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.findProxy = (uri) {
            return "PROXY $host:$port";
          };
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        };
      }
    }
  }

  /// TODO 增加头部信息
  void addHeader(String key, dynamic value) {
    _headers[key] = value;
  }

  /// TODO 删除头部信息
  void removeHeader(String key) {
    if (_headers.containsKey(key)) {
      _headers.remove(key);
    }
  }

  /// TODO 增加透传参数
  void addExtra(String key, String value) {
    _extra[key] = value;
  }

  /// TODO 删除透传参数
  void removeExtra(String key) {
    if (_extra.containsKey(key)) {
      _extra.remove(key);
    }
  }

  /// TODO 增加请求参数
  void addParam(String key, String value) {
    _params[key] = value;
  }

  /// TODO 删除请求参数
  void removeParam(String key, String value) {
    if (_params.containsKey(key)) {
      _params.remove(key);
    }
  }

  /// TODO 增加文件参数
  void addFile(String key, String value) async {
    File file = File(value);
    if (file.existsSync()) {
      _files[key] = await MultipartFile.fromFile(value);
    }
  }

  /// TODO 删除文件参数
  void removeFile(String key, String value) {
    if (_files.containsKey(key)) {
      _files.remove(key);
    }
  }

  /// TODO 增加拦截器
  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  /// TODO 拼接参数
  FormData _buildParams() {
    Map<String, dynamic> other = Map();
    if (this._params != null && this._params.isNotEmpty) {
      other.addAll(this._params);
    }
    return FormData.fromMap(other);
  }

  /// TODO 拼接文件参数
  FormData _buildFileParams() {
    Map<String, dynamic> other = Map();
    if (this._params != null && this._params.isNotEmpty) {
      other.addAll(this._params);
    }

    if (this._files != null && this._files.isNotEmpty) {
      other.addAll(this._files);
    }
    return FormData.fromMap(other);
  }

  String _buildUrl(String url) {
    return Uri.encodeFull(url);
  }

  /// TODO 进行get请求
  ///   connectTimeout 连接超时时间
  ///   sendTimeout 发送超时时间
  ///   receiveTimeout 接收超时时间
  ///   cancelToken 取消句柄
  Future<Response> get(
      {int connectTimeout = 10000,
      int sendTimeout = 10000,
      int receiveTimeout = 10000,
      CancelToken cancelToken,
      ResponseType responseType,
      int maxRedirects,
      ProgressCallback onReceiveProgress}) async {
    Response response = await dio.get(_buildUrl(url),
        options: new RequestOptions(
            headers: _headers,
            method: 'GET',
            connectTimeout: connectTimeout,
            sendTimeout: sendTimeout,
            receiveTimeout: receiveTimeout,
            extra: _extra,
            queryParameters: _params,
            responseType: responseType,
            maxRedirects: maxRedirects),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
    return _handlerResponse(response);
  }

  /// TODO 进行POST请求
  ///   connectTimeout 连接超时时间
  ///   sendTimeout 发送超时时间
  ///   receiveTimeout 接收超时时间
  ///   cancelToken 取消句柄
  Future<Response> post(
      {int connectTimeout = 10000,
      int sendTimeout = 10000,
      int receiveTimeout = 10000,
      CancelToken cancelToken,
      ResponseType responseType,
      int maxRedirects,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress}) async {
    var data;
    if (_files.isNotEmpty) {
      data = _buildFileParams();
    } else {
      data = _buildParams();
    }
    Response response = await dio.post(
        _buildUrl(
          url,
        ),
        options: new RequestOptions(
          headers: _headers,
          method: 'POST',
          connectTimeout: connectTimeout,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
          extra: _extra,
          responseType: responseType,
          maxRedirects: maxRedirects,
        ),
        cancelToken: cancelToken,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress);
    return _handlerResponse(response);
  }

  Future<Response> download(
      {int connectTimeout = 10000,
      int sendTimeout = 10000,
      int receiveTimeout = 10000,
      savePath,
      String method: "GET",
      CancelToken cancelToken,
      ResponseType responseType,
      int maxRedirects,
      ProgressCallback onReceiveProgress}) async {
    var data = _buildParams();
    Response response = await dio.download(
        _buildUrl(
          url,
        ),
        savePath,
        options: new RequestOptions(
          headers: _headers,
          method: method,
          connectTimeout: connectTimeout,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
          extra: _extra,
          responseType: responseType,
          maxRedirects: maxRedirects,
        ),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        data: data);
    return _handlerResponse(response);
  }

  Response _handlerResponse(Response response) {
    if (response.statusCode != 200) {
      throw new Exception(
          "服务请求异常, ${response.statusCode} ${response.toString()}");
    }
    return response;
  }
}

FormData lowerCaseCompareByFormData(FormData formData) {
  List<MapEntry<String, dynamic>> data =
      formData.fields.toList(growable: false);
  data.sort((a, b) {
    return a.key.toLowerCase().compareTo(b.key.toLowerCase());
  });

  return FormData.fromMap(Map.fromEntries(data));
}

Map<String, dynamic> lowerCaseCompareByMap(Map<String, dynamic> mapData) {
  List<MapEntry<String, dynamic>> data =
      mapData.entries.toList(growable: false);
  data.sort((a, b) {
    return a.key.toLowerCase().compareTo(b.key.toLowerCase());
  });

  return Map.fromEntries(data);
}
