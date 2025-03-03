import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditate_app/components/bubbles/bubble_floating_animation.dart';
import 'package:simple_animations/simple_animations.dart';

/// Enum for setting the shape of the bubble.
enum BubbleShape { circle, square, roundedRectangle }

/// Creates floating bubbles in the foreground of any widget.
class FloatingBubbles extends StatefulWidget {
  final int noOfBubbles;
  final List<Color> colorsOfBubbles;
  final double sizeFactor;
  int? duration;
  final int opacity;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final BubbleShape shape;

  FloatingBubbles({
    super.key,
    required this.noOfBubbles,
    required this.colorsOfBubbles,
    required this.sizeFactor,
    required this.duration,
    this.shape = BubbleShape.circle,
    this.opacity = 100,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeWidth = 0,
  })  : assert(noOfBubbles >= 10, 'Number of bubbles cannot be less than 10'),
        assert(sizeFactor > 0 && sizeFactor < 0.5,
            'Size factor must be between 0 and 0.5'),
        assert(duration != null && duration >= 0,
            'Duration must not be null or negative'),
        assert(opacity >= 0 && opacity <= 255,
            'Opacity must be between 0 and 255'),
        assert(
            colorsOfBubbles.isNotEmpty, 'At least one color must be specified');

  FloatingBubbles.alwaysRepeating({
    super.key,
    required this.noOfBubbles,
    required this.colorsOfBubbles,
    required this.sizeFactor,
    this.shape = BubbleShape.circle,
    this.opacity = 60,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeWidth = 0,
  })  : assert(noOfBubbles >= 10, 'Number of bubbles cannot be less than 10'),
        assert(sizeFactor > 0 && sizeFactor < 0.5,
            'Size factor must be between 0 and 0.5'),
        assert(opacity >= 0 && opacity <= 255,
            'Opacity must be between 0 and 255') {
    duration = 0;
  }

  @override
  _FloatingBubblesState createState() => _FloatingBubblesState();
}

class _FloatingBubblesState extends State<FloatingBubbles> {
  final Random random = Random();
  int checkToStopAnimation = 0;
  final List<BubbleFloatingAnimation> bubbles = [];

  @override
  void initState() {
    final _random = Random();
    for (int i = 0; i < widget.noOfBubbles; i++) {
      bubbles.add(
        BubbleFloatingAnimation(
          random,
          color: widget
              .colorsOfBubbles[_random.nextInt(widget.colorsOfBubbles.length)],
        ),
      );
    }
    if (widget.duration != null && widget.duration != 0) {
      Timer(Duration(seconds: widget.duration!), () {
        setState(() {
          checkToStopAnimation = 1;
        });
      });
    }
    super.initState();
  }

  CustomPaint drawBubbles({required CustomPainter bubbles}) {
    return CustomPaint(
      painter: bubbles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.duration == 0 && widget.duration != null
        ? LoopAnimationBuilder<double>(
            duration: const Duration(seconds: 1),
            tween: ConstantTween(1),
            builder: (context, value, child) {
              _simulateBubbles();
              return drawBubbles(
                bubbles: BubbleModel(
                  bubbles: bubbles,
                  sizeFactor: widget.sizeFactor,
                  opacity: widget.opacity,
                  paintingStyle: widget.paintingStyle,
                  strokeWidth: widget.strokeWidth,
                  shape: widget.shape,
                ),
              );
            },
          )
        : PlayAnimationBuilder<double>(
            duration: checkToStopAnimation == 0
                ? Duration(seconds: widget.duration!)
                : Duration.zero,
            tween: ConstantTween(1),
            builder: (context, value, child) {
              _simulateBubbles();
              return checkToStopAnimation == 0
                  ? drawBubbles(
                      bubbles: BubbleModel(
                        bubbles: bubbles,
                        sizeFactor: widget.sizeFactor,
                        opacity: widget.opacity,
                        paintingStyle: widget.paintingStyle,
                        strokeWidth: widget.strokeWidth,
                        shape: widget.shape,
                      ),
                    )
                  : Container();
            },
          );
  }

  void _simulateBubbles() {
    for (var bubble in bubbles) {
      bubble.checkIfBubbleNeedsToBeRestarted();
    }
  }
}
