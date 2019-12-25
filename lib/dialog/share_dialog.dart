import 'package:flibrary_plugin/model/menu.dart';
import 'package:flibrary_plugin/widget/button/button.dart';
import 'package:flutter/material.dart';

class ShareDialog extends StatelessWidget {
  final bool clickWhiteAreaClose;
  final double itemSpacing;
  final int crossAxisCount;
  final double childAspectRatio;
  final List<Menu> menus;
  final EdgeInsets itemPadding;
  final Size iconSize;
  final EdgeInsets margin;
  final Alignment alignment;
  final BorderRadius borderRadius;

  const ShareDialog(
      {Key key,
      this.clickWhiteAreaClose,
      this.itemSpacing: 0,
      this.crossAxisCount: 4,
      this.childAspectRatio: 1,
      this.menus: const [],
      this.itemPadding: const EdgeInsets.only(),
      this.iconSize: const Size(40, 40),
      this.margin: const EdgeInsets.all(10),
      this.alignment: Alignment.bottomCenter,
      this.borderRadius: const BorderRadius.all(Radius.circular(0))})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (clickWhiteAreaClose == true) {
          Navigator.pop(context);
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: this.alignment,
          child: Card(
            elevation: 0,
            margin: this.margin,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            child: GridView.builder(
                physics: new NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: this.childAspectRatio,
                    crossAxisCount: this.crossAxisCount,
                    mainAxisSpacing: this.itemSpacing),
                shrinkWrap: true,
                itemCount: this.menus.length,
                itemBuilder: buildItem),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    Menu menu = menus[index];
    BorderRadius borderRadius;
    if (index == 0) {
      borderRadius = BorderRadius.only(
          topLeft: this.borderRadius.topLeft,
          bottomLeft: this.borderRadius.bottomLeft);
    } else if (index == menus.length - 1) {
      borderRadius = BorderRadius.only(
          topRight: this.borderRadius.topRight,
          bottomRight: this.borderRadius.bottomRight);
    } else {
      borderRadius = BorderRadius.all(Radius.circular(0));
    }
    return Button(
      child: Padding(
        padding: itemPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              menu.defaultIcon,
              width: iconSize.width,
              height: iconSize.height,
            ),
            Center(
              child: Text(
                menu.name,
                maxLines: 1,
                style: menu.defaultTextStyle,
              ),
            )
          ],
        ),
      ),
      activeChild: Padding(
        padding: itemPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset(
              menu.activeIcon != null && menu.activeIcon.isNotEmpty
                  ? menu.activeIcon
                  : menu.defaultIcon,
              width: iconSize.width,
              height: iconSize.height,
            ),
            Center(
              child: Text(
                menu.name,
                style: menu.activeTextStyle != null
                    ? menu.activeTextStyle
                    : menu.defaultTextStyle,
              ),
            )
          ],
        ),
      ),
      defaultColor: menu.defaultColor,
      activeColor: menu.activeColor,
      borderRadius: borderRadius,
      onPress: menu.onPress,
    );
  }
}
