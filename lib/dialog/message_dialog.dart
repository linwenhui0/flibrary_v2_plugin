import 'package:flibrary_plugin/model/menu.dart';
import 'package:flibrary_plugin/widget/button/button.dart';
import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final Size size;
  final Color backgroundColor;
  final bool showTitle;
  final double titleHeight;
  final Widget title;
  final String titleText;
  final TextStyle titleStyle;
  final Color titleBackground;
  final bool showMessage;
  final Widget message;
  final String messageText;
  final TextStyle messageStyle;
  final List<Menu> buttonMenus;
  final double buttonHeight;
  final Color dividerColor;
  final BorderRadius borderRadius;

  const MessageDialog({
    Key key,
    @required this.size,
    this.titleBackground: Colors.white,
    this.backgroundColor: Colors.white,
    this.showTitle: true,
    this.titleHeight: 45,
    this.title,
    this.titleText: "",
    this.titleStyle,
    this.showMessage: true,
    this.message,
    this.messageText: "",
    this.messageStyle,
    this.buttonMenus,
    this.buttonHeight: 0,
    this.dividerColor,
    this.borderRadius: const BorderRadius.all(Radius.circular(6)),
  })  : assert(size != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        color: backgroundColor,
        child: SizedBox.fromSize(
          size: size,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Offstage(
                child: buildTitle(),
                offstage: !showTitle,
              ),
              Expanded(
                child: Offstage(
                  child: buildMessage(),
                  offstage: !showMessage,
                ),
              ),
              Divider(
                height: 1,
                color: dividerColor,
              ),
              SizedBox(
                height: buttonHeight,
                child: buildButtons(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    if (title != null) {
      return title;
    }
    return SizedBox(
      height: titleHeight,
      child: Material(
        borderRadius: BorderRadius.only(
            topLeft: this.borderRadius.topLeft,
            topRight: this.borderRadius.topRight),
        color: this.titleBackground,
        child: Center(
          child: Text(
            titleText,
            maxLines: 1,
            style: titleStyle,
          ),
        ),
      ),
    );
  }

  Widget buildMessage() {
    if (message != null) {
      return message;
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Text(
          messageText,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: messageStyle,
        ),
      ),
    );
  }

  Widget buildButtons() {
    List<Widget> btns = [];
    int index = 0;
    final int len = buttonMenus.length - 1;
    for (Menu menu in buttonMenus) {
      BorderRadius borderRadius;
      if (index == 0) {
        borderRadius =
            BorderRadius.only(bottomLeft: this.borderRadius.bottomLeft);
      } else if (index == len) {
        borderRadius =
            BorderRadius.only(bottomRight: this.borderRadius.bottomRight);
      } else {
        borderRadius = BorderRadius.only();
      }
      btns.add(Expanded(
          child: Button(
        borderRadius: borderRadius,
        onPress: menu.onPress,
        color: menu.defaultColor,
        child: Center(
          child: Text(
            menu.name,
            style: menu.defaultTextStyle,
          ),
        ),
        activeColor: menu.activeColor,
        activeChild: Center(
            child: Text(
          menu.name,
          style: menu.activeTextStyle != null
              ? menu.activeTextStyle
              : menu.defaultTextStyle,
        )),
      )));
      btns.add(VerticalDivider(
        width: 1,
        color: dividerColor,
      ));
      index++;
    }
    btns.removeLast();
    return Row(
      children: btns,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
