import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

final double maxSliderValue = 1000.0;
final double viewPadding = 16.0;

void main() {
  runApp(
    new MaterialApp(
      title: "Flutter Sunflower",
      routes: { '/': (RouteArguments args) => new SunflowerDemo() }
    )
  );
}

class SunflowerDemo extends StatefulComponent {
  SunflowerState createState() => new SunflowerState();
}

class SunflowerState extends State<SunflowerDemo> {
  static const Color orange = const Color(0xFFFFA500);

  double _value = 500.0;

  Widget build(BuildContext context) {
    return new Scaffold(
      toolBar: new ToolBar(
        center: new Text("Flutter Sunflower"),
        right: [
          new Slider(
            min: 0.0,
            value: _value,
            max: maxSliderValue,
            activeColor: Theme.of(context).canvasColor,
            onChanged: (double value) {
              setState(() {
                _value = value;
              });
            }
          )
        ]
      ),
      body: new Material(
        child: new Padding(
          child: new CustomPaint(
            painter: new SunflowerPainter(
              color: orange,
              seeds: _value
            )
          ),
          padding: new EdgeDims.all(viewPadding)
        )
      )
    );
  }
}

class SunflowerPainter extends CustomPainter {
  SunflowerPainter({
    this.color,
    this.seeds
  });

  static const double tau = math.PI * 2;
  static final double phi = (math.sqrt(5) + 1) / 2;

  final Color color;
  final double seeds;

  void paint(Canvas canvas, Size size) {
    print('seed value = ${seeds}');

    double maxDimension = math.min(size.width, size.height);
    double scaleFactor = (maxDimension / 2.0) / math.sqrt(maxSliderValue);
    double seedRadius = scaleFactor * 0.6;

    double xCenter = size.width / 2;
    double yCenter = size.height / 2;
    double tauPhiRatio = tau / phi;

    Paint paint = new Paint()
      ..color = color
      ..style = ui.PaintingStyle.fill;

    for (int i = 0; i < seeds; i++) {
      double theta = i * tauPhiRatio;
      double r = math.sqrt(i) * scaleFactor;
      canvas.drawCircle(new Point(
        xCenter + r * math.cos(theta),
        yCenter - r * math.sin(theta)
      ), seedRadius, paint);
    }
  }

  bool shouldRepaint(SunflowerPainter oldPainter) {
    return oldPainter.color != color || oldPainter.seeds != seeds;
  }
}
