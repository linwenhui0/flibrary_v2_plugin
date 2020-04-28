import 'package:flutter/material.dart';

class CircleWave extends StatefulWidget {
  final Size size;
  final double radius;
  final int waveRate;
  final double gradientWidth;
  final bool run;
  final Duration duration;
  final Color color;

  const CircleWave(
      {Key key,
      this.size,
      this.radius,
      this.waveRate,
      this.gradientWidth,
      this.run,
      this.duration: const Duration(seconds: 1),
      this.color: const Color(0xffcdb175)})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CircleWaveState();
  }
}

class _CircleWaveState extends State<CircleWave>
    with SingleTickerProviderStateMixin {
  List<double> waveList;
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    waveList = List.filled(widget.waveRate, 0);
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener(onAnimationState);
  }

  void onAnimationState(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (widget.run == true) {
        _controller.forward(from: 0.0);
      } else {
        waveList = List.filled(widget.waveRate, 0);
        _controller.reset();
      }
    }
  }

  void updateWaveValues(double rate) {
    print("updateWaveValues rate($rate)");
    for (int i = 0; i < waveList.length; i++) {
      double v = rate - i.toDouble() / widget.waveRate;
      if (v < 0 && waveList[i] > 0) {
        v += 1;
      }
      waveList[i] = v;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.run == true) {
      _controller.forward();
    }
    return SizedBox.fromSize(
      size: widget.size,
      child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            updateWaveValues(_animation.value);
            return CustomPaint(
              size: widget.size,
              painter: CircleWavePaint(
                  radius: widget.radius,
                  gradientWidth: widget.gradientWidth,
                  waveList: waveList,
                  color: widget.color),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeStatusListener(onAnimationState);
    _controller?.dispose();
  }
}

class CircleWavePaint extends CustomPainter {
  final double radius;
  final double gradientWidth;
  final List<double> waveList;
  final Color color;

  CircleWavePaint({this.radius, this.gradientWidth, this.waveList, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = gradientWidth / waveList.length
      ..color = color;

    for (double waveValue in waveList) {
      double r = waveValue * gradientWidth;
      if (r > 0) {
        print(
            "waveValue($waveValue) alpha(${(255 * (1 - waveValue)).toInt()}) radius($r)");
        paint.color = color.withAlpha((255 * (1 - waveValue)).toInt());
        canvas.drawCircle(
            Offset(size.width / 2, size.height / 2), r + radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    print("shouldRepaint ");
    return true;
  }
}
