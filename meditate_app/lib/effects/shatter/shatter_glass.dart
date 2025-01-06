import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'delauney.dart'; // Replace with your actual import paths
import 'face.dart'; // Replace with your actual import paths
import 'fragment.dart'; // Replace with your actual import paths
import 'vertex.dart'; // Replace with your actual import paths

class ShatterGlass extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShatterGlass({
    required Key key,
    required this.child,
    required this.duration,
  }) : super(key: key);

  @override
  _ShatterGlassState createState() => _ShatterGlassState();
}

class _ShatterGlassState extends State<ShatterGlass>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  double posX = 0.0;
  double posY = 0.0;
  late DelaunayTriangulation triangulation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Optionally, add post-animation cleanup or logic here.
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating || _controller.isCompleted) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _startAnimation(context),
        child: widget.child,
      );
    }

    final Offset origin = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );

    int index = 0;
    final int size = triangulation.faces.length;

    return Stack(
      children: <Widget>[
        ...triangulation.faces.map((face) {
          double delay = (index++ / size) *
              widget.duration.inSeconds *
              _randomRange(0.8, 0.9);
          return Fragment(
            controller: _controller,
            child: _clip(face, widget.child),
            posX: posX,
            posY: posY,
            delay: delay,
            duration: widget.duration.inSeconds,
            face: face,
            center: origin,
            key: UniqueKey(),
          );
        }),
      ],
    );
  }

  void _startAnimation(BuildContext context) {
    if (_controller.isAnimating) {
      return; // Prevent restarting animation if already running.
    }

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(
      MediaQuery.of(context).size.center(Offset.zero),
    );

    final newTriangulation = _triangulate(localOffset.dx, localOffset.dy);

    setState(() {
      posX = localOffset.dx;
      posY = localOffset.dy;
      triangulation = newTriangulation;
    });

    _controller.forward(from: 0.0); // Start animation from beginning.
    HapticFeedback.vibrate();
  }

  DelaunayTriangulation _triangulate(double centerX, double centerY) {
    const double twoPi = 2 * pi;
    final List<Offset> vertices = [Offset(centerX, centerY)];

    final List<List<int>> rings = [
      [50, 12],
      [150, 12],
      [300, 12],
      [1200, 12],
    ];

    for (var ring in rings) {
      int radius = ring[0];
      int count = ring[1];
      double variance = radius * 0.25;

      for (int i = 0; i < count; i++) {
        double x = cos((i / count) * twoPi) * radius +
            centerX +
            _randomRange(-variance, variance);
        double y = sin((i / count) * twoPi) * radius +
            centerY +
            _randomRange(-variance, variance);
        vertices.add(Offset(x, y));
      }
    }

    return DelaunayTriangulation(
      vertices.map((e) => Vertex(e.dx, e.dy)),
    );
  }

  double _randomRange(double min, double max) {
    return min + (max - min) * Random().nextDouble();
  }

  ClipPath _clip(Face face, Widget widget) {
    return ClipPath(
      clipper: MyCustomClipper(face),
      child: widget,
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final Face face;

  MyCustomClipper(this.face);

  @override
  Path getClip(Size size) {
    return Path()
      ..addPolygon(
        [
          Offset(face.a.x, face.a.y),
          Offset(face.b.x, face.b.y),
          Offset(face.c.x, face.c.y),
        ],
        true,
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
