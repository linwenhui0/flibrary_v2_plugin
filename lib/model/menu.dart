import 'package:flutter/material.dart';

enum MenuCategory { text }

class Menu {
  int id;
  String name;
  String defaultIcon;
  String activeIcon;
  MenuCategory menuCategory;
  VoidCallback onPress;
  TextStyle defaultTextStyle;
  TextStyle activeTextStyle;
  Color defaultColor;
  Color activeColor;

  Menu(
      {this.name,
      this.onPress,
      this.id: 0,
      this.menuCategory: MenuCategory.text,
      this.defaultTextStyle,
      this.activeTextStyle,
      this.defaultIcon,
      this.activeIcon,
      this.defaultColor,
      this.activeColor});
}
