import 'package:flutter/material.dart';

class CircleWave extends StatelessWidget {
  final Size size;
  final double radius;
  final int waveRate;
  final double gradientWidth;
  final int offset;

  const CircleWave(
      {Key key,
      this.size,
      this.radius,
      this.waveRate,
      this.gradientWidth,
      this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        size: size,
        painter: CircleWavePaint(radius, waveRate, gradientWidth, offset),
      ),
    );
  }
}

class CircleWavePaint extends CustomPainter {
  final double radius;
  final int waveRate;
  final double gradientWidth;
  final int offset;

  CircleWavePaint(this.radius, this.waveRate, this.gradientWidth, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    Color color = const Color(0xffcdb175);
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = gradientWidth / waveRate
      ..color = color;

    paint.color = color.withAlpha((waveRate - offset) * 256 ~/ waveRate);
    print("index = 0 , alpha = ${paint.color.alpha} radius($radius)");
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        offset * gradientWidth / waveRate + radius, paint);
    for (int i = 1 + offset; i < waveRate; i++) {
      paint.color = color.withAlpha((i - offset) * 256 ~/ waveRate);
      print(
          "index = $i , alpha = ${paint.color.alpha} radius(${(waveRate - i ) * gradientWidth / waveRate + radius})");

      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          (waveRate - i ) % waveRate * gradientWidth / waveRate +
              radius,
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
