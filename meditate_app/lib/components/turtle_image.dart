import 'package:flutter/material.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtleImage extends StatelessWidget {
  final int id;
  final int color;
  const TurtleImage({super.key, required this.id, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("assets/images/turtles/swim/swim1.png"),
        id != 21
            ? Container()
            : Image.asset("assets/images/turtles/21_underlay.png"),
        id >= 0 && id < TURTLES.length
            ? (color == 18
                ? ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.5),
                          Colors.red.withOpacity(0.5),
                          Colors.orange.withOpacity(0.5),
                          Colors.yellow.withOpacity(0.5),
                          Colors.green.withOpacity(0.5),
                          Colors.blue.withOpacity(0.5),
                          Colors.indigo.withOpacity(0.5),
                          Colors.purple.withOpacity(0.5),
                          Colors.purple.withOpacity(0.5),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Image.asset("assets/images/turtles/$id.png"),
                  )
                : ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        TURTLE_COLORS[color].withOpacity(0.5),
                        BlendMode.srcATop),
                    child: Image.asset("assets/images/turtles/$id.png"),
                  ))
            : Container(),
        id != 10
            ? Container()
            : Image.asset("assets/images/turtles/10_overlay.png"),
        id != 23
            ? Container()
            : Image.asset("assets/images/turtles/23_overlay.png"),
      ],
    );
  }
}
