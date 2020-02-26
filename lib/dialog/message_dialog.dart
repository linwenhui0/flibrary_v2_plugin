import 'package:flibrary_plugin/model/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/util/density.dart';

typedef IndexedButtonWidgetBuilder = Widget Function(
    BuildContext context, int index);
typedef IndexedButtonDivideWidgetBuilder = Widget Function(
    BuildContext context, int index);

class MessageDialog extends StatelessWidget {
  final Size size;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Color dividerColor;

  final TitleMenu titleMenu;
  final Color titleDividerColor;
  final MessageMenu messageMenu;

  final int buttonSize;
  final double buttonHeight;
  final IndexedButtonWidgetBuilder buttonBuilder;
  final IndexedButtonDivideWidgetBuilder buttonDivideBuilder;

  const MessageDialog({
    Key key,
    @required this.size,
    this.backgroundColor: Colors.white,
    this.dividerColor: Colors.grey,
    this.borderRadius: const BorderRadius.all(Radius.circular(6)),
    this.titleMenu: const TitleMenu(),
    this.titleDividerColor: Colors.black,
    this.messageMenu,
    this.buttonSize,
    this.buttonHeight: 0,
    this.buttonBuilder,
    this.buttonDivideBuilder,
  })  : assert(size != null),
        assert(buttonBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(color: backgroundColor),
          child: SizedBox.fromSize(
            size: size,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Offstage(
                  child: buildTitle(),
                  offstage: !titleMenu.showTitle,
                ),
                Divider(
                  height: 1,
                  color: titleDividerColor,
                ),
                Expanded(
                  child: Offstage(
                    child: buildMessage(),
                    offstage: !messageMenu.showMessage,
                  ),
                ),
                Divider(
                  height: 1,
                  color: dividerColor,
                ),
                SizedBox(
                  height: buttonHeight,
                  child: buildButtons(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return titleMenu.widget ??
        SizedBox(
          height: titleMenu.height,
          child: DecoratedBox(
            decoration: BoxDecoration(color: titleMenu.titleBackground),
            child: Center(
              child: Text(
                titleMenu.title,
                maxLines: 1,
                style: titleMenu.titleTextStyle,
              ),
            ),
          ),
        );
  }

  Widget buildMessage() {
    return messageMenu.widget ??
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Density().autoPx(25)),
            child: Text(
              messageMenu.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: messageMenu.messageTextStyle,
            ),
          ),
        );
  }

  Widget buildButtons(BuildContext context) {
    List<Widget> btns = [];
    for (int index = 0; index < buttonSize; index++) {
      btns.add(buttonBuilder(context, index));
      if (index != buttonSize - 1) {
        btns.add(buttonDivideBuilder(context, index));
      }
    }
    return Row(
      children: btns,
    );
  }
}
