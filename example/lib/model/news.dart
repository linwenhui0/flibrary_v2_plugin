class News {
  String title;
  String time;
  String src;
  String category;
  String pic;
  String content;
  String url;
  String weburl;

  News(
      {this.title,
      this.time,
      this.src,
      this.category,
      this.pic,
      this.content,
      this.url,
      this.weburl});

  News.fromMap(Map map) {
    title = map["title"];
    time = map["time"];
    src = map["src"];
    category = map["category"];
    pic = map["pic"];
    content = map["content"];
    url = map["url"];
    weburl = map["weburl"];
  }
}
