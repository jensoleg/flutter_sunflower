import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

final double maxSliderValue = 1000.0;

void main() {
  runApp(
    new MaterialApp(
      title: "Strober Demo",
      routes: {
        Navigator.defaultRouteName: (_) => new StroberDemo()
      }
    )
  );
}

class StroberDemo extends StatefulComponent {
  StroberState createState() => new StroberState();
}

class StroberState extends State<StroberDemo> {
  StroberState() {
    _startTimer();
  }

  double dialation = 1.0;
  bool paused = false;

  FpsCounter fpsCounter = new FpsCounter();
  Timer _timer;

  Widget build(BuildContext context) {
    fpsCounter.tick();

    // print(fpsCounter.fps);

    return new Scaffold(
      toolBar: new ToolBar(
        center: new Text("Strober"),
        right: <Widget>[
          new Slider(
            min: 0.2,
            value: dialation,
            max: 3.0,
            activeColor: Theme.of(context).canvasColor,
            onChanged: (double value) {
              setState(() {
                dialation = value;
              });
            }
          ),
          new Switch(
            value: !paused,
            activeColor: Theme.of(context).canvasColor,
            onChanged: _togglePaused
          )
        ]
      ),
      body: new Container(
        child: new CustomPaint(
          painter: new StroberPainter(
            color: Colors.orange[500],
            seeds: _seedValue()
          )
        ),
        padding: const EdgeDims.all(16.0)
      ),
      floatingActionButton: new Material(
        child: new Chip(
          label: new Text('${fpsCounter.fps.round()}')
        )
      )
    );
  }

  void _startTimer() {
    fpsCounter.reset();
    _timer = new Timer.periodic(new Duration(milliseconds: (1000 / 60).round()), (_) {
      setState(() { });
    });
  }

  void _togglePaused(bool newValue) {
    setState(() {
      paused = !paused; //newValue;

      if (paused) {
        _timer?.cancel();
      } else {
        _startTimer();
      }
    });
  }

  double _seedValue() {
    double time = new DateTime.now().millisecondsSinceEpoch * dialation % 2000.0;
    if (time > 1000.0)
      time = 2000.0 - time;
    return time;
  }
}

class StroberPainter extends CustomPainter {
  static final double phi = (math.sqrt(5) + 1) / 2;

  static List<Color> palette = [Colors.white, Colors.black];

  StroberPainter({
    this.color,
    this.seeds
  });

  final Color color;
  final double seeds;

  void paint(Canvas canvas, Size size) {
    double maxDimension = math.min(size.width, size.height);
    double scaleFactor = (maxDimension / 2.0) / math.sqrt(maxSliderValue);
    double seedRadius = scaleFactor * 0.6;

    double xCenter = size.width / 2;
    double yCenter = size.height / 2;
    double tauPhiRatio = (math.PI * 2) / phi;

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

  bool shouldRepaint(StroberPainter oldPainter) {
    return oldPainter.color != color || oldPainter.seeds != seeds;
  }
}

class FpsCounter {
  static final maxSamples = 180;

  List<int> samples = [];

  double get fps {
    if (samples.length < 2) {
      return 0.0;
    } else {
      return samples.length * 1000.0 / (samples.last - samples.first);
    }
  }

  void reset() => samples.clear();

  void tick() {
    samples.add(new DateTime.now().millisecondsSinceEpoch);
    if (samples.length > maxSamples) samples.removeAt(0);
  }
}
