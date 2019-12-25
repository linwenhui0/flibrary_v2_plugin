import 'package:flibrary_plugin/model/menu.dart';
import 'package:flibrary_plugin/widget/button/button.dart';
import 'package:flutter/material.dart';

class ItemDialog extends StatelessWidget {
  final List<Menu> menus;
  final Menu cancelMenu;
  final double cancelHeight;
  final double itemHeight;
  final EdgeInsets margin;
  final AlignmentGeometry alignment;
  final bool visualCancel;
  final double borderRadius;
  final EdgeInsets cancelMargin;
  final String title;
  final TextStyle titleStyle;
  final double titleHeight;

  const ItemDialog(this.menus, this.cancelMenu,
      {Key key,
      this.borderRadius: 8,
      this.alignment: Alignment.bottomCenter,
      this.margin: EdgeInsets.zero,
      this.itemHeight: 20,
      this.cancelHeight: 20,
      this.visualCancel: true,
      this.cancelMargin: const EdgeInsets.only(top: 10),
      this.title: "",
      this.titleStyle,
      this.titleHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        if (cancelMenu != null && cancelMenu.onPress != null) {
          cancelMenu.onPress();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: margin,
          child: Align(
            alignment: alignment,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(borderRadius)),
                  child: Column(
                    children: [
                      InkWell(
                        child: SizedBox(
                          height: titleHeight,
                          child: Center(
                            child: Text(
                              title,
                              style: titleStyle,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      Wrap(
                        children: menus.map((menu) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                              Button(
                                child: SizedBox(
                                  height: itemHeight,
                                  child: Center(
                                    child: Text(
                                      menu.name,
                                      style: menu.defaultTextStyle,
                                    ),
                                  ),
                                ),
                                activeChild: SizedBox(
                                  height: itemHeight,
                                  child: Center(
                                    child: Text(
                                      menu.name,
                                      style: menu.activeTextStyle ??
                                          menu.defaultTextStyle,
                                    ),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(0),
                                onPress: menu.onPress,
                                defaultColor: menu.defaultColor,
                                activeColor:
                                    menu.activeColor ?? menu.defaultColor,
                              ),
                            ],
                          );
                        }).toList(),
                      )
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
                Offstage(
                  child: Padding(
                    padding: this.cancelMargin,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(borderRadius)),
                      child: Button(
                        child: SizedBox(
                          height: cancelHeight,
                          child: Center(
                            child: Text(
                              cancelMenu.name,
                              style: cancelMenu.defaultTextStyle,
                            ),
                          ),
                        ),
                        activeChild: SizedBox(
                          height: cancelHeight,
                          child: Center(
                            child: Text(
                              cancelMenu.name,
                              style: cancelMenu.activeTextStyle ??
                                  cancelMenu.defaultTextStyle,
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(borderRadius),
                        onPress: () {
                          Navigator.pop(context);
                          if (cancelMenu.onPress != null) {
                            cancelMenu.onPress();
                          }
                        },
                        defaultColor: cancelMenu.defaultColor,
                        activeColor:
                            cancelMenu.activeColor ?? cancelMenu.defaultColor,
                      ),
                    ),
                  ),
                  offstage: !this.visualCancel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
