import 'dart:async';

import 'package:flutter/material.dart';

/// TODO 接收手机验证码
class ReceiverCodeButton extends StatefulWidget {
  final int initSeconds;
  final TextEditingController controller;
  final String defaultText;
  final String waitCodeTextPre, waitCodeTextSuffix;
  final TextStyle textStyle;
  final Color backgroundColor, waitBackgroundColor;
  final RoundedRectangleBorder shape;
  final VoidCallback onPressed;
  final ReceiverCodeController receiverCodeController;

  const ReceiverCodeButton(
      this.initSeconds, this.controller, this.receiverCodeController,
      {Key key,
      this.defaultText,
      this.waitCodeTextPre,
      this.waitCodeTextSuffix,
      this.textStyle,
      this.backgroundColor,
      this.waitBackgroundColor,
      this.shape,
      this.onPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReceiverCodeButtonState();
  }
}

class _ReceiverCodeButtonState extends State<ReceiverCodeButton>
    with IReceiverCodeListener {
  int codeSeconds = -1;
  Timer codeTime;

  @override
  void dispose() {
    super.dispose();
    stopCountTimer();
    widget.receiverCodeController._receiverCodes.remove(this);
  }

  @override
  void initState() {
    super.initState();
    widget.receiverCodeController._receiverCodes.add(this);
  }

  @override
  Widget build(BuildContext context) {
    if (codeSeconds < 0) {
      return buildDefault();
    }
    return buildCountDownTimer();
  }

  @override
  void startCountTimer() {
    if (widget.controller != null && widget.controller.text.isNotEmpty) {
      if (codeSeconds < 0) {
        codeSeconds = widget.initSeconds;
        codeTime?.cancel();
        codeTime = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          if (codeSeconds < 0) {
            codeTime?.cancel();
            return;
          }
          codeSeconds--;
          setState(() {});
        });
        setState(() {});
      }
    }
  }

  @override
  void stopCountTimer() {
    codeSeconds = -1;
    codeTime?.cancel();
    codeTime = null;
  }

  Widget buildDefault() {
    return FlatButton(
        padding: EdgeInsets.all(0),
        color: widget.backgroundColor,
        shape: widget.shape,
        onPressed: () {
          if (widget.controller != null &&
              widget.controller.text.isNotEmpty &&
              widget.onPressed != null) {
            widget.onPressed();
          }
        },
        child: Text(
          widget.defaultText,
          style: widget.textStyle,
        ));
  }

  Widget buildCountDownTimer() {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: widget.waitBackgroundColor,
          borderRadius: widget.shape?.borderRadius),
      child: Center(
        child: Text(
          "${widget.waitCodeTextPre}$codeSeconds${widget.waitCodeTextSuffix}",
          style: widget.textStyle,
        ),
      ),
    );
  }
}

class ReceiverCodeController {
  List<IReceiverCodeListener> _receiverCodes = List();

  void startCountTimer() {
    if (_receiverCodes.isNotEmpty) {
      for (IReceiverCodeListener listener in _receiverCodes) {
        listener.startCountTimer();
      }
    }
  }

  void stopCountTimer() {
    if (_receiverCodes.isNotEmpty) {
      for (IReceiverCodeListener listener in _receiverCodes) {
        listener.stopCountTimer();
      }
    }
  }
}

abstract class IReceiverCodeListener {
  void startCountTimer();

  void stopCountTimer();
}
