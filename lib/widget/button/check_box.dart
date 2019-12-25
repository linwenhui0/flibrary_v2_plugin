import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final Widget checkedChild;
  final Widget defaultChild;
  final ValueChanged<bool> onChange;
  final Color defaultColor, checkedColor;
  final bool defaultCheck;
  final BorderRadius borderRadius;

  const CheckBox({
    Key key,
    this.defaultCheck: false,
    this.checkedChild,
    this.defaultChild,
    this.defaultColor,
    this.checkedColor,
    this.borderRadius,
    this.onChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckBoxState();
  }
}

class _CheckBoxState extends State<CheckBox> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = widget.defaultCheck;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.setState(() {
          isActive = !isActive;
          if (widget.onChange != null) {
            widget.onChange(isActive);
          }
        });
      },
      splashColor: widget.defaultColor,
      highlightColor: widget.checkedColor ?? widget.defaultColor,
      borderRadius: widget.borderRadius,
      child: isActive
          ? (widget.checkedChild ?? widget.defaultChild)
          : widget.defaultChild,
    );
  }
}
