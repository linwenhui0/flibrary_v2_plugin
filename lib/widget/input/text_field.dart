import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// TODO  带删除输入框
// ignore: must_be_immutable
class TextFieldInput extends StatefulWidget {
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final EdgeInsets contentPadding;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String hintText;
  final TextStyle hintStyle;
  final bool obscureText;
  final String labelText;
  final TextStyle labelStyle;
  final Widget icon;
  final Widget prefix;
  final Widget prefixIcon;
  final String prefixText;
  final TextStyle prefixStyle;
  final Widget suffixIcon;
  final double closeIconSize;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final int maxLines;
  final InputBorder border;
  final InputBorder focusedBorder;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final bool showClose;
  final Color fillColor;
  final bool filled;
  final bool enabled;

  final int maxLength;
  final TextStyle style;

  TextFieldInput(
      {Key key,
      this.controller,
      this.inputFormatters,
      this.contentPadding,
      this.textInputAction: TextInputAction.done,
      this.keyboardType,
      this.labelText,
      this.labelStyle,
      this.hintText,
      this.hintStyle,
      this.obscureText: false,
      this.icon,
      this.prefix,
      this.prefixIcon,
      this.prefixText,
      this.prefixStyle,
      this.suffixIcon,
      this.textAlign: TextAlign.start,
      this.focusNode,
      this.maxLines,
      this.border,
      this.focusedBorder,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.showClose: true,
      this.closeIconSize: 16,
      this.fillColor,
      this.filled,
      this.maxLength,
      this.style,
      this.enabled: true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextFieldInputState();
  }
}

class _TextFieldInputState extends State<TextFieldInput> {
  TextEditingController _controller;
  EdgeInsets _contentPadding;
  InputBorder _border;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if (_controller == null) {
      _controller = TextEditingController();
    }
    if (widget.border == null) {
      _border = UnderlineInputBorder();
    } else {
      _border = widget.border;
    }
    if (widget.contentPadding != null) {
      _contentPadding = EdgeInsets.only(
          top: widget.contentPadding.top + _border.borderSide.width,
          bottom: widget.contentPadding.bottom + _border.borderSide.width,
          left: widget.contentPadding.left,
          right: widget.contentPadding.right);
    } else {
      _contentPadding = EdgeInsets.only(
          top: _border.borderSide.width, bottom: _border.borderSide.width);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Offstage(
      child: SizedBox(
        child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              _controller.clear();
              if (widget.onChanged != null) {
                widget.onChanged("");
              }
              this.setState(() {});
            },
            child: Icon(
              Icons.close,
              size: widget.closeIconSize,
            )),
        width: 50,
      ),
      offstage: !(widget.showClose == true && _controller.text.isNotEmpty),
    ));
    if (widget.suffixIcon != null) {
      children.add(widget.suffixIcon);
    }
    return TextField(
      controller: _controller,
      maxLength: widget.maxLength,
      style: widget.style,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      focusNode: widget.focusNode,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged(value);
        }
        this.setState(() {});
      },
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
          contentPadding: _contentPadding,
          labelText: widget.labelText,
          labelStyle: widget.labelStyle,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          border: _border,
          focusedBorder: widget.focusedBorder,
          enabledBorder: _border,
          fillColor: widget.fillColor,
          filled: widget.filled,
          icon: widget.icon,
          prefix: widget.prefix,
          prefixIcon: widget.prefixIcon,
          prefixText: widget.prefixText,
          prefixStyle: widget.prefixStyle,
          enabled: widget.enabled,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          )),
    );
  }
}
