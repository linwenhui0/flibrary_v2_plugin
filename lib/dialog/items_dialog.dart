import 'package:flibrary_plugin/model/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'message_dialog.dart'
    show IndexedButtonDivideWidgetBuilder, IndexedButtonWidgetBuilder;

class ItemDialog extends StatelessWidget {
  final TitleMenu titleMenu;
  final Color titleDividerColor;

  final double cancelMarginTop;
  final TitleMenu cancelMenu;

  final double borderRadius;
  final Color backgroundColor;
  final int itemCount;
  final IndexedButtonWidgetBuilder itemBuilder;
  final IndexedButtonDivideWidgetBuilder itemDividerBuilder;
  final EdgeInsets margin;

  const ItemDialog(
      {Key key,
      this.titleMenu: const TitleMenu(),
      this.titleDividerColor: Colors.grey,
      this.cancelMarginTop: 8,
      this.cancelMenu: const TitleMenu(),
      this.borderRadius: 8,
      this.backgroundColor: Colors.white,
      this.itemCount: 3,
      this.itemBuilder,
      this.itemDividerBuilder,
      this.margin: const EdgeInsets.all(0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Offstage(
        child: buildTitle(),
        offstage: !titleMenu.showTitle,
      ),
      Divider(
        height: 1,
        thickness: 1,
        color: titleDividerColor,
      ),
    ];

    for (int index = 0; index < itemCount; index++) {
      children.add(itemBuilder(context, index));
      if (index != itemCount - 1) {
        children.add(itemDividerBuilder(context, index));
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: margin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius)),
              child: Column(
                children: children,
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            Offstage(
              child: Padding(
                padding: EdgeInsets.only(top: cancelMarginTop),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: buildCancel(context),
                ),
              ),
              offstage: !cancelMenu.showTitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return titleMenu.widget ??
        GestureDetector(
          child: SizedBox(
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
          ),
          onTap: () {},
        );
  }

  Widget buildCancel(BuildContext context) {
    return cancelMenu.widget ??
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: SizedBox(
            height: cancelMenu.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cancelMenu.titleBackground,
              ),
              child: Center(
                child: Text(
                  cancelMenu.title,
                  maxLines: 1,
                  style: cancelMenu.titleTextStyle,
                ),
              ),
            ),
          ),
        );
  }
}
