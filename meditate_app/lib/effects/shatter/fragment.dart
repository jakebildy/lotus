import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meditate_app/effects/shatter/face.dart';

/// Inspired by https://codepen.io/willhelm/pen/GqBVRA

class Fragment extends StatefulWidget {
  final Widget child;
  final double posX;
  final double posY;
  final Offset center;
  final double delay;
  final int duration;
  final Face face;
  final AnimationController controller;

  const Fragment({
    required this.controller,
    required this.child,
    required this.posX,
    required this.posY,
    required this.delay,
    required this.duration,
    required this.face,
    required this.center,
    required Key key,
  }) : super(key: key);

  @override
  _FragmentState createState() => _FragmentState();
}

class _FragmentState extends State<Fragment>
    with SingleTickerProviderStateMixin {
  late Animation<double> _rx;
  late Animation<double> _opacity;
  late Interval curve;

  @override
  void initState() {
    super.initState();
    curve = Interval(
      widget.delay / widget.duration,
      1.0,
      curve: Curves.fastOutSlowIn,
    );
    double signX = _sign(widget.face.centroid.x - widget.posX);
    _rx = Tween(begin: 0.0, end: 60.0 * signX).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: curve,
      ),
    );
    _opacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: curve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: widget.controller,
          builder: _buildAnimation,
        ),
      ],
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Stack(
      children: [
        Transform(
          origin: Offset(widget.center.dx, widget.center.dy * 2),
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.01)
            ..rotateX(_rx.value * pi / 180),
          child: Opacity(
            opacity: _opacity.value,
            child: widget.child,
          ),
        ),
      ],
    );
  }

  double _sign(double x) {
    return x < 0 ? -1 : 1;
  }
}

class Point extends StatelessWidget {
  final double x;
  final double y;

  const Point(this.x, this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y,
      left: x,
      child: Container(
        width: 5,
        height: 5,
        color: Colors.red,
      ),
    );
  }
}
