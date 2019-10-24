import 'dart:async';

import 'package:flutter/material.dart';

/// TODO 接收手机验证码
class ReceiverCodeButton extends StatefulWidget {
  final int initSeconds;
  final TextEditingController controller;
  final Widget defaultChild;
  final WaitCountTimer onWaitCountTimer;
  final SendSmsCheck onSendSmsCheck;

  const ReceiverCodeButton(this.initSeconds, this.controller,
      {Key key, this.defaultChild, this.onWaitCountTimer, this.onSendSmsCheck})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReceiverCodeButtonState();
  }
}

class _ReceiverCodeButtonState extends State<ReceiverCodeButton> {
  int codeSeconds = -1;
  Timer codeTime;

  @override
  void dispose() {
    super.dispose();
    stopCountTimer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (codeSeconds < 0) {
      return buildDefault();
    }
    return buildCountDownTimer();
  }

  void startCountTimer() {
    if (widget.controller != null &&
        widget.controller.text?.isNotEmpty == true) {
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

  void stopCountTimer() {
    codeSeconds = -1;
    codeTime?.cancel();
    codeTime = null;
  }

  Widget buildDefault() {
    return InkWell(
      child: widget.defaultChild,
      onTap: () {
        String phone = widget.controller.text;
        if (widget.onSendSmsCheck != null) {
          bool isSendSms = widget.onSendSmsCheck(phone);
          if (isSendSms == true) {
            startCountTimer();
          }
        }
      },
    );
  }

  Widget buildCountDownTimer() {
    return widget.onWaitCountTimer(codeSeconds);
  }
}

typedef WaitCountTimer = Widget Function(int count);

typedef SendSmsCheck = bool Function(String phone);
