import 'package:flibrary_plugin_example/model/news.dart';
import 'package:flutter/material.dart';
import 'package:flibrary_plugin/logic/net.dart';
import 'package:dio/dio.dart';

class ImageListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageListState();
  }
}

class _ImageListState extends State<ImageListPage> {
  List<News> newsList = [];

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    requestData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  void requestData() async {
    Request request = Request();
    request.url =
        "https://way.jd.com/jisuapi/get?channel=头条&num=40&start=0&appkey=0f183ae2c1ee9dce7bf135a9e8bd4a9c";
    Response response = await request.get(
        connectTimeout: 30000, receiveTimeout: 30000, sendTimeout: 30000);
    if (response?.statusCode == 200) {
      if (response.data is Map) {
        Map map = response.data;
        if (map.containsKey("result") == true) {
          Map resultMap = map["result"];
          if (resultMap.containsKey("status") == true &&
              "0" == "${resultMap["status"]}") {
            if (resultMap.containsKey("result") == true) {
              Map subResultMap = resultMap["result"];
              if (subResultMap.containsKey("list") == true) {
                List list = subResultMap["list"];
                List<News> datas = [];
                if (list?.isNotEmpty == true) {
                  for (dynamic map in list) {
                    if (map is Map) {
                      datas.add(News.fromMap(map));
                    }
                  }
                }

                if (datas.isNotEmpty == true) {
                  newsList.addAll(datas);
                  this.setState(() {});
                }
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("列表测试"),
      ),
      body: NotificationListener(
          // ignore: missing_return
          onNotification: (Notification notification) {
            if (notification is ScrollEndNotification) {
              if (_scrollController.position.extentAfter == 0) {
                requestData();
              }
            }
          },
          child: ListView.separated(
            controller: _scrollController,
              itemBuilder: (context, index) {
                News news = newsList[index];
                return Image.network(news.pic);
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: newsList.length)),
    );
  }
}
