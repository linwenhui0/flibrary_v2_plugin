import 'package:flutter/material.dart';

class Menu {
  final int id;
  final Widget widget;

  const Menu({this.id: 0, this.widget});
}

class TitleMenu extends Menu {
  final String title;
  final TextStyle titleTextStyle;
  final bool showTitle;
  final double height;
  final Color titleBackground;

  const TitleMenu({
    int id: 0,
    Widget widget,
    this.title,
    this.titleBackground,
    this.height,
    this.showTitle: true,
    this.titleTextStyle,
  }) : super(id: id, widget: widget);
}

class MessageMenu extends Menu {
  final String message;
  final TextStyle messageTextStyle;
  final bool showMessage;

  const MessageMenu({
    int id: 0,
    Widget widget,
    this.message,
    this.showMessage: true,
    this.messageTextStyle,
  }) : super(id: id, widget: widget);
}

class ButtonMenu extends Menu {
  final Widget activeWidget;

  ButtonMenu({int id, Widget widget, this.activeWidget})
      : super(id: id, widget: widget);
}
