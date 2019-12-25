import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Widget child;
  final Widget activeChild;
  final VoidCallback onPress;
  final Color defaultColor;
  final Color activeColor;
  final BorderRadius borderRadius;

  const Button(
      {Key key,
      this.child,
      this.activeChild,
      this.onPress,
      this.defaultColor,
      this.activeColor,
      this.borderRadius: const BorderRadius.all(Radius.circular(4))})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ButtonState();
  }
}

class _ButtonState extends State<Button> {
  bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.onPress != null) {
            widget.onPress();
          }

          this.setState(() {
            active = false;
          });
        },
        onTapDown: (TapDownDetails details) {
          this.setState(() {
            active = true;
          });
        },
        onTapCancel: () {
          this.setState(() {
            active = false;
          });
        },
        borderRadius: widget.borderRadius,
        splashColor: widget.defaultColor,
        highlightColor: widget.activeColor ?? widget.defaultColor,
        child: active == true
            ? (widget.activeChild ?? widget.child)
            : widget.child);
  }
}
