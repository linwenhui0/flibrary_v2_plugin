import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flibrary_plugin/annotation/database/annotation_manager.dart';
import 'package:flibrary_plugin/dialog/items_dialog.dart';
import 'package:flibrary_plugin/dialog/message_dialog.dart';
import 'package:flibrary_plugin/dialog/share_dialog.dart';
import 'package:flibrary_plugin/logic/net.dart'
    show Request, lowerCaseCompareByFormData;
import 'package:flibrary_plugin/logic/net.dart';
import 'package:flibrary_plugin/model/menu.dart';
import 'package:flibrary_plugin/plugins/FLibraryPlugin.dart';
import 'package:flibrary_plugin/widget/button/button.dart';
import 'package:flibrary_plugin/widget/button/check_box.dart';
import 'package:flibrary_plugin/widget/button/receiver_code_button.dart';
import 'package:flibrary_plugin/widget/input/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_permissions/flutter_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_utils/util/density.dart';
import 'package:flutter_utils/util/utils_path.dart';
import 'package:flutter_utils/util/print.dart';
import 'package:flutter_utils/util/network_utils.dart';
import 'package:flutter_utils/util/device_util.dart';
import 'package:flutter_utils/util/encrypt/encrypt_help.dart';
import 'db/database_test.dart';
import 'db/school.dart';
import 'db/student.dart';

void main() {
  runApp(new App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseManager()
        .init("main.db", 1, [SchoolDatabaseTable(), StudentDatabaseTable()]);
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StringBuffer textBuffer;
  FocusNode _focusNodeFirstName = new FocusNode();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textBuffer = new StringBuffer();
  }

  @override
  Widget build(BuildContext context) {
    Density().init();
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Plugin example app'),
      ),
      body: new ListView(
        children: <Widget>[
          new MaterialButton(
            onPressed: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              bool b = await sp.setString("key", "123");
              setState(() {
                textBuffer.write("保存sp结果:$b\n");
              });
            },
            child: new Text(
              "保存sp",
              style: TextStyle(fontSize: Density().autoPx(32)),
            ),
          ),
          new MaterialButton(
            onPressed: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              String b = sp.getString("key");
              setState(() {
                textBuffer.write("保存sp结果:$b\n");
              });
            },
            child: new Text(
              "读取sp",
            ),
          ),
          new Container(
            child: Row(
              children: <Widget>[
                Image.network(
                  "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3797481993,1929347741&fm=27&gp=0.jpg",
                  fit: BoxFit.fitWidth,
                  width: Density().autoPx(719.0),
                  height: Density().autoPx(30.0),
                )
              ],
            ),
            color: Colors.amber,
          ),
          new Container(
            child: new Text("宽度720，设计稿宽度720，1080"),
            color: Colors.deepOrange,
            width: Density().autoPx(720.0),
          ),
          new Container(
            child: new Text("宽度719，设计稿宽度720，1080"),
            color: Colors.amber,
            width: Density().autoPx(719.0),
          ),
          new Container(
            child: new Text("宽度720，设计稿宽度720，1080"),
            color: Colors.purple,
            height: Density().autoPx(540.0),
          ),
          new Container(
            color: Colors.amber,
            height: Density().autoPx(1.0),
          ),
          new MaterialButton(
            onPressed: () async {
              Request request = new Request();
              request.url = "http://www.weather.com.cn/data/sk/101190408.html";
//              request.url = "http://apis.juhe.cn/simpleWeather/query";
              request.addParam("key", "87b69f34a73d84c858f480c95bf6048c");
              request.addParam("city", "上海");
              request.addInterceptor(new TestInterceptorsWrapper());
              Response respond = await request.post();
              setState(() {
                textBuffer
                  ..write(respond.statusCode)
                  ..write("\n")
                  ..write(respond.headers)
                  ..write("\n")
                  ..write(respond.data)
                  ..write("\n");
              });
            },
            child: new Text("获得天气情况"),
          ),
          new MaterialButton(
            onPressed: () async {
              bool respond = await PathUtil.haveExternalStorage();
              setState(() {
                textBuffer.write("是否存在sd卡 $respond\n");
              });
            },
            child: new Text("是否存在sd卡"),
          ),
          new MaterialButton(
            onPressed: () async {
              Dao dao = DatabaseManager().getDao("tb_school");

              var res = await DatabaseTest.insert(1, "demo1", 1);
              setState(() {
                textBuffer.write("插入数据库结果 $res\n");
              });
            },
            child: new Text("插入数据库"),
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                filled: true,
                labelText: "First name *"),
          ),
          new MaterialButton(
            onPressed: () async {
              Dao dao = DatabaseManager().getDao("tb_school");
              List result = await dao.query();
              if (result != null && result.isNotEmpty) {
                setState(() {
                  textBuffer.write("读取数据库school表，结果 $result  \n");
                });
              } else {
                setState(() {
                  textBuffer.write("读取数据库school表，暂无数据  \n");
                });
              }
            },
            child: new Text("读取数据库school表"),
          ),
          new MaterialButton(
            onPressed: () async {
              Dao dao = DatabaseManager().getDao("tb_school");
              bool result =
                  await dao.insert(object: School(name: "一中", level: 1));
              if (result == true) {
                setState(() {
                  textBuffer.write("写入数据库school表，成功  \n");
                });
              } else {
                setState(() {
                  textBuffer.write("写入数据库school表，失败  \n");
                });
              }
            },
            child: new Text("写入数据库school表"),
          ),
          new MaterialButton(
            onPressed: () async {
              Dao dao = DatabaseManager().getDao("tb_school");
              bool result = await dao.update(
                  object:
                      School(name: "一中 ${DateTime.now()}", level: 1, id: 1));
              if (result == true) {
                setState(() {
                  textBuffer.write("更新数据库school表，成功  \n");
                });
              } else {
                setState(() {
                  textBuffer.write("更新数据库school表，失败  \n");
                });
              }
            },
            child: new Text("更新数据库school表，id:1"),
          ),
          new MaterialButton(
            onPressed: () async {
              Dao dao = DatabaseManager().getDao("tb_school");
              List tbSchools = await dao.query();
              if (tbSchools != null && tbSchools.isNotEmpty) {
                School school = tbSchools[tbSchools.length - 1];
                bool result = await dao.delete(object: school);
                if (result == true) {
                  setState(() {
                    textBuffer.write("删除数据库school表，成功  \n");
                  });
                } else {
                  setState(() {
                    textBuffer.write("删除数据库school表，失败  \n");
                  });
                }
              }
            },
            child: new Text("删除数据库school表，id:4"),
          ),
          TextFormField(
            focusNode: _focusNodeFirstName,
            decoration: const InputDecoration(
                border: const UnderlineInputBorder(),
                filled: true,
                labelText: "First name *"),
          ),
          new MaterialButton(
            onPressed: () async {
              PermissionStatus state =
                  await FlutterPermissions.requestPermission(
                      Permission.WriteExternalStorage);
              print("state($state)");
            },
            child: new Text("sd卡权限"),
          ),
          new MaterialButton(
            onPressed: () {
              Print().printNative("日志写入测试", level: Print.ERROR);
            },
            child: new Text("日志写入测试"),
          ),
          SizedBox(
            child: new Button(
              child: Center(
                child: Text("default"),
              ),
              activeChild: Center(
                child: Text("active"),
              ),
            ),
            height: Density().autoPx(90),
          ),
          SizedBox(
            child: CheckBox(
              defaultChild: Center(
                child: Text("未选中"),
              ),
              checkedChild: Center(
                child: Text("选中"),
              ),
              defaultColor: Colors.blue,
              checkedColor: Colors.red,
              onChange: (value) {
                textBuffer.write("切换选中状态：$value\n");
                this.setState(() {});
              },
            ),
            height: Density().autoPx(100),
          ),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                suffix: SizedBox(
              child: ReceiverCodeButton(
                10,
                phoneController,
                onSendSmsCheck: (String phone) {
                  if (phone?.length == 11) {
                    return true;
                  }
                  return false;
                },
                defaultChild: Center(
                  child: Text("获得验证码"),
                ),
                onWaitCountTimer: (int timer) {
                  return Container(
                    child: Center(
                      child: Text("($timer)"),
                    ),
                    height: Density().autoPx(80),
                    color: Colors.grey,
                  );
                },
              ),
              width: Density().autoPx(160),
              height: Density().autoPx(80),
            )),
          ),
          TextFieldInput(
            prefixIcon: Material(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Density().autoPx(20)),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "账号",
                    style: TextStyle(fontSize: Density().autoPx(20)),
                  ),
                  widthFactor: 1,
                ),
              ),
              color: Colors.blue,
            ),
            hintText: "请输入帐号",
            hintStyle: TextStyle(
              fontSize: Density().autoPx(20),
            ),
            onEditingComplete: () {
              Print().printNative("onEditingComplete");
            },
            onSubmitted: (text) {
              Print().printNative("onSubmitted $text");
            },
            contentPadding:
                EdgeInsets.symmetric(vertical: Density().autoPx(20)),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: Density().autoPx(20),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            maxLines: 1,
            showClose: true,
            closeIconSize: 20,
          ),
          FlatButton(
              onPressed: () {
                String result = EncryptHelp.encodeMd5("123456");
                textBuffer.write("result($result)\n");
                this.setState(() {});
              },
              child: Text("md5 生成值")),
          FlatButton(
              onPressed: () async {
                String result = await DeviceUtil.getMode();
                textBuffer.write("手机型号($result)\n");
                this.setState(() {});
              },
              child: Text("手机型号")),
          FlatButton(
              onPressed: () async {
                String result = await DeviceUtil.getPhoneType();
                textBuffer.write("获取设备类型($result)\n");
                this.setState(() {});
              },
              child: Text("获取设备类型")),
          FlatButton(
              onPressed: () async {
                String result = await DeviceUtil.getSystemVersion();
                textBuffer.write("获取系统版本($result)\n");
                this.setState(() {});
              },
              child: Text("获取系统版本")),
          FlatButton(
              onPressed: () async {
                String result = await DeviceUtil.getDeviceLanguage();
                textBuffer.write("手机的当前语言设置($result)\n");
                this.setState(() {});
              },
              child: Text("手机的当前语言设置")),
          FlatButton(
              onPressed: () async {
                bool result = await NetworkUtil.isConnected();
                textBuffer.write("网络是否连接($result)\n");
                this.setState(() {});
              },
              child: Text("判断网络是否连接")),
          FlatButton(
              onPressed: () async {
                String result = await NetworkUtil.getCurrentNetworkType();
                textBuffer.write("获取当前网络类型($result)\n");
                this.setState(() {});
              },
              child: Text("获取当前网络类型")),
          FlatButton(
              onPressed: () async {
                String result = await FLibraryPlugin.getMacAddress();
                textBuffer.write("获取wifi mac地址($result)\n");
                this.setState(() {});
              },
              child: Text("获取wifi mac地址")),
          FlatButton(
              onPressed: () async {
                String result = await FLibraryPlugin.getRouteWifiMac();
                textBuffer.write("获取路由器地址($result)\n");
                this.setState(() {});
              },
              child: Text("获取路由器地址")),
          FlatButton(
              onPressed: () async {
                String result = await DeviceUtil.getSerial();
                textBuffer.write("获取设备序列号($result)\n");
                this.setState(() {});
              },
              child: Text("获取设备序列号")),
          FlatButton(
              onPressed: () async {
                String result = await FLibraryPlugin.getImei;
                textBuffer.write("获取IMEI($result)\n");
                this.setState(() {});
              },
              child: Text("获取IMEI")),
          FlatButton(
              onPressed: () async {
                bool result = await FLibraryPlugin.isRoot();
                textBuffer.write("是否已root($result)\n");
                this.setState(() {});
              },
              child: Text("是否已root")),
          FlatButton(
              onPressed: () async {
                bool result = await FLibraryPlugin.isVpn();
                textBuffer.write("是否开启VPN($result)\n");
                this.setState(() {});
              },
              child: Text("是否开启VPN")),
          FlatButton(
              onPressed: () async {
                String result = await FLibraryPlugin.getIDFA();
                textBuffer.write("获得IDFA($result)\n");
                this.setState(() {});
              },
              child: Text("获得IDFA")),
          FlatButton(
              onPressed: () async {
                String result = await FLibraryPlugin.getIDFV();
                textBuffer.write("获得IDFV($result)\n");
                this.setState(() {});
              },
              child: Text("获得IDFV")),
          FlatButton(
              onPressed: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return MessageDialog(
                        size:
                            Size(Density().autoPx(500), Density().autoPx(300)),
                        titleMenu: TitleMenu(
                            title: "提示",
                            titleTextStyle: TextStyle(
                                fontSize: Density().autoPx(30),
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            height: Density().autoPx(60)),
                        messageMenu: MessageMenu(
                          message: "内容" * 20,
                          messageTextStyle: TextStyle(
                              fontSize: Density().autoPx(30),
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        buttonSize: 2,
                        buttonBuilder: (context, index) {
                          return Expanded(
                              child: CupertinoButton(
                            color: Colors.white,
                            padding: EdgeInsets.zero,
                            borderRadius: BorderRadius.zero,
                            child: Text(
                              index == 0 ? "取消" : "确定",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Density().autoPx(24)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ));
                        },
                        dividerColor: Colors.grey,
                        buttonHeight: Density().autoPx(80),
                        buttonDivideBuilder: (context, index) {
                          return VerticalDivider(
                            color: Colors.grey,
                            width: 1,
                            thickness: 1,
                          );
                        },
                        borderRadius: BorderRadius.all(
                            Radius.circular(Density().autoPx(10))),
                      );
                    });
              },
              child: Text("消息对话框")),
          FlatButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ShareBottomAnimationDialog(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        backgroundColor: Colors.white,
                        childAspectRatio: 1.1,
                        crossAxisCount: 3,
                        itemCount: 3,
                        itemBuilder: (context, index, onCloseDialog) {
                          return CupertinoButton(
                              child: Image.asset(
                                "res/images/icon_qq_login.png",
                                width: Density().autoPx(100),
                                height: Density().autoPx(100),
                              ),
                              onPressed: () {
                                if (onCloseDialog != null) {
                                  onCloseDialog();
                                }
                              });
                        },
                      );
                    });
              },
              child: Text("分享对话框")),
          FlatButton(
              onPressed: () async {
                Map<String, String> map = getDeviceInfo();
                Map<String, dynamic> otherMap = lowerCaseCompareByMap(map);
                Print().printNative("otherMap($otherMap)");
              },
              child: Text("map根据key排序")),
          DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("res/images/icon_qq_login.png"))),
            position: DecorationPosition.background,
            child: SizedBox(
              height: Density().autoPx(200),
              child: Text("背景"),
            ),
          ),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green, Colors.red]),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 4.0)
                  ]),
              position: DecorationPosition.background,
              child: SizedBox(
                height: Density().autoPx(100),
                width: Density().autoPx(300),
                child: Text("背景"),
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: new Image.asset(
              'res/images/icon_qq_login.png',
              width: Density().autoPx(300),
              height: Density().autoPx(300),
              fit: BoxFit.fill,
              centerSlice: Rect.fromLTRB(
                  Density().autoPx(90),
                  Density().autoPx(90),
                  Density().autoPx(130),
                  Density().autoPx(130)),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    centerSlice: Rect.fromLTRB(
                        Density().autoPx(90),
                        Density().autoPx(90),
                        Density().autoPx(130),
                        Density().autoPx(130)),
                    image: AssetImage("res/images/icon_qq_login.png"))),
            position: DecorationPosition.background,
            child: SizedBox(
              height: Density().autoPx(300),
              child: Text("背景"),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: Density().autoPx(60), top: Density().autoPx(60)),
                child: SizedBox(
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blue)),
                  height: Density().autoPx(60),
                  width: Density().autoPx(200),
                ),
              )
            ],
          ),
          RaisedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ItemBottomAnimationDialog(
                      titleMenu: TitleMenu(
                          title: "请选择",
                          height: Density().autoPx(100),
                          titleTextStyle: TextStyle(color: Colors.black)),
                      titleDividerColor: Colors.black,
                      cancelMarginTop: Density().autoPx(20),
                      cancelMenu: TitleMenu(
                          title: "取消",
                          titleBackground: Colors.white,
                          height: Density().autoPx(100),
                          titleTextStyle: TextStyle(color: Colors.black)),
                      itemCount: 3,
                      itemBuilder: (context, index, onCloseDialog) {
                        return InkWell(
                          child: SizedBox(
                            height: Density().autoPx(80),
                            child: Center(
                              child: Text(
                                "item $index",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      itemDividerBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      margin: EdgeInsets.only(
                          left: Density().autoPx(20),
                          right: Density().autoPx(20),
                          bottom: Density().autoPx(20)),
                    );
                  });
            },
            child: Text("显示item dialog"),
          ),
          RaisedButton(
            onPressed: () async {
              PermissionStatus permissionStatus =
                  await FlutterPermissions.requestPermissions([
                Permission.ReadExternalStorage,
                Permission.WriteExternalStorage
              ]);
              if (permissionStatus == PermissionStatus.authorized) {
                Request request = new Request();
//                request.url =
//                    "http://m.gdown.baidu.com/a2877e2bfbe1e332753886621a18d704ce4ddfaaf74030e290bc6334adba2330315b131fa4116105b5e6839e6fd1c9dc1580975bdace534bb52d2f9fe5509cf722c5cda5c9d1809479f557baf56c10b3af50a920303a5fca2093102d7e6c0d3e00a1351f1f8a7fe7b40a971e73eb1b81119fab94fdf93057100f96902cc0518b25d618db79d1c7c38c8435390eb1be5d";
                request.url =
                    "https://apkks.mushao.com/promote/10/p_10_565_jgyolg.apk?AppVer=1257014655696506885";
                try {
                  Response response = await request.download(
                      savePath: (headers) {
                        String fileName = "aa.apk";
                        String contentDisposition =
                            headers.value("content-disposition");
                        if (contentDisposition != null) {
                          List<String> contentDispositions =
                              contentDisposition.split(";");

                          for (String content in contentDispositions) {
                            if (content.startsWith("filename=")) {
                              fileName = content
                                  .replaceAll("\"", "")
                                  .replaceAll("filename=", "");
                              break;
                            }
                          }
                          print(
                              "fileName $fileName ${contentDisposition.runtimeType}");
                        }
                        print(headers);

                        return "/sdcard/$fileName";
                      },
                      sendTimeout: 100000,
                      connectTimeout: 100000,
                      receiveTimeout: 100000,
                      onReceiveProgress: (int count, int total) {});
                  print("下载返回数据");
                  print(response.data);
                } catch (e) {
                  print("下载出错 $e");
                }
              }
            },
            child: Text("下载apk"),
          ),
          new Text(textBuffer.toString())
        ],
      ),
    );
  }

  Map<String, String> getDeviceInfo() {
    Map<String, String> map = {};
    // 通用信息
    // 系统类型
    map["OSType"] = "2";

    // 设备
    map["DeviceType"] = "";
    // 系统版本号
    map["OSVer"] = "";
    // 设备类型
    map["DeviceModel"] = "";
    // 设备语言
    map["DeviceLang"] = "";
    // 程序语言
    map["AppLang"] = "";
    // 网络类型
    map["Net"] = "";
    // Mac地址
    map["Mac"] = "";
    // 屏幕分辨率
    map["Screen"] = "";
    // 路由地址
    map["BSSID"] = "";
    // 设备序列号
    map["Serial"] = "";
    // 程序唯一标识
    map["OpenID"] = "";
    // 设备唯一标识
    map["IMEI"] = "";
    // 是否越狱

    map["JbFlag"] = "1";

    // 系统iOS
    // 广告标识
    map["IDFA"] = "";
    // 开发者唯一标识
    map["IDFV"] = "";
    // 开机启动时间
    map["RTime"] = "";
    // Token
    map["Token"] = "";
    // 第三方广告标识
    map["SimIDFA"] = "";

    // 项目信息
    // 产品标识
    map["PID"] = "";
    // 渠道标识
    map["CHID"] = "";
    // SDK程序版本
    map["SDKVerNo"] = "";
    // SDK内部程序版本
    map["SDKVer"] = "";
    // 程序更新版本
    map["AppVerNo"] = "";
    // 程序内部更新版本
    map["AppVer"] = "";
    // 程序ID
    map["AppID"] = "";
    // 包名
    map["PackageName"] = "";
    // 接口协议内部版本
    map["ApiVer"] = "";
    // 接口协议版本
    map["ApiVerNo"] = "";
    // 用户标识
    map["UserID"] = "";
    // 自动登录码
    map["AutoCode"] = "";
    // 推广员标识
    map["PromoteID"] = "";
    // 游戏版本号
    map["GameVerNo"] = "";
    // 游戏内部版本
    map["GameVer"] = "";
    // 企业签名
    map["SignID"] = "";
    return map;
  }
}

class TestInterceptorsWrapper extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    await Future.delayed(Duration(seconds: 1));
    FormData formData = options.data;
    FormData otherData = lowerCaseCompareByFormData(formData);
    options.path = "http://apis.juhe.cn/simpleWeather/query";
    Print().printNative("data(${otherData.fields})");
    Print().printNative(
        "onRequest url(${options.baseUrl + options.path}) data(${formData.fields.runtimeType} ${formData.fields}) header(${options.headers} queryParameters(${options.queryParameters})");
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  onError(DioError err) {
    return super.onError(err);
  }
}
