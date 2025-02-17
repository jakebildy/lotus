import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foil/foil.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:xl/xl.dart';
import 'new_egg_page.dart';
import 'package:glitters/glitters.dart';

class StarburstPainter extends CustomPainter {
  final Color color;
  final double rotation;

  StarburstPainter({
    this.color = Colors.yellow,
    this.rotation = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const numberOfRays = 12;
    const rayLength = 160.0;
    const rayWidth = 15.0;
    const innerCircleRadius = 20.0;

    for (var i = 0; i < numberOfRays; i++) {
      final angle = (i * 2 * pi / numberOfRays) + rotation;
      final path = Path();

      final point1 = Offset(
        center.dx + rayLength * cos(angle),
        center.dy + rayLength * sin(angle),
      );
      final point2 = Offset(
        center.dx + innerCircleRadius * cos(angle + 0.3),
        center.dy + innerCircleRadius * sin(angle + 0.3),
      );
      final point3 = Offset(
        center.dx + innerCircleRadius * cos(angle - 0.3),
        center.dy + innerCircleRadius * sin(angle - 0.3),
      );

      path.moveTo(point2.dx, point2.dy);
      path.lineTo(point1.dx, point1.dy);
      path.lineTo(point3.dx, point3.dy);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(StarburstPainter oldDelegate) =>
      color != oldDelegate.color || rotation != oldDelegate.rotation;
}

class LevelUpPage extends StatefulWidget {
  final bool foundEgg;

  const LevelUpPage({Key? key, required this.foundEgg}) : super(key: key);

  @override
  State<LevelUpPage> createState() => _LevelUpPageState();
}

class _LevelUpPageState extends State<LevelUpPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 180),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Glitters(
                    interval: Duration(milliseconds: 3800),
                    delay: Duration(milliseconds: 1100),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 180),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Glitters(
                    interval: Duration(milliseconds: 4000),
                    delay: Duration(milliseconds: 800),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 180),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Glitters(
                    interval: Duration(milliseconds: 2000),
                    delay: Duration(milliseconds: 1000),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: SizedBox(
                            height: 190,
                            width: 150,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      painter: StarburstPainter(
                                        color: Colors.yellow.withOpacity(0.2),
                                        rotation: _controller.value * 2 * pi,
                                      ),
                                      size: const Size(300, 300),
                                    );
                                  },
                                ),
                                XL(layers: [
                                  XLayer(
                                      xRotation: 0.4,
                                      yRotation: 0.4,
                                      xOffset: 4,
                                      yOffset: 4,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Text(
                                            "⭐️",
                                            style: TextStyle(fontSize: 140),
                                          ),
                                          const Opacity(
                                            opacity: 0.4,
                                            child: Foil(
                                                child: Text(
                                              "⭐️",
                                              style: TextStyle(fontSize: 140),
                                            )),
                                          ),
                                          Shimmer.fromColors(
                                            baseColor: Colors.white12,
                                            highlightColor: Colors.white38,
                                            child: const Text(
                                              "⭐️",
                                              style: TextStyle(fontSize: 140),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4, 0, 0),
                                            child: Text(
                                              (calculateLevel(
                                                      user.user.value
                                                          .levelPoints,
                                                      user.user.value))
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 50,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 10.0,
                                                      color: Colors.black,
                                                      offset: Offset(0, 0.0),
                                                    ),
                                                    Shadow(
                                                      blurRadius: 10.0,
                                                      color: Colors.black,
                                                      offset: Offset(0, 0.0),
                                                    ),
                                                    Shadow(
                                                      blurRadius: 10.0,
                                                      color: Colors.black,
                                                      offset: Offset(0, 0.0),
                                                    ),
                                                  ],
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.lightBlueAccent),
                                            ),
                                          )
                                        ],
                                      )),
                                ]),
                              ],
                            ),
                          ),
                        )),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: StrokeText(
                          text: "LEVEL UP",
                          strokeColor: Color.fromRGBO(0, 91, 165, 1),
                          strokeWidth: 5,
                          textStyle: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              // color gradient from orange to white

                              color: Colors.white)),

                      // Text("LEVEL UP",
                      //     style: const TextStyle(
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.lightBlueAccent)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "You reached Level " +
                              calculateLevel(user.user.value.levelPoints,
                                      user.user.value)
                                  .toString() +
                              "!",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.foundEgg) {
                          Get.offAll(const NewEggPage());
                        } else {
                          Get.offAll(const AppPages());
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          // color: const Color.fromARGB(255, 16, 77, 127),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 100),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
