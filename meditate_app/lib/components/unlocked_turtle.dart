import 'package:flutter/material.dart';
import 'package:meditate_app/util/turtles.dart';

class UnlockedTurtle extends StatelessWidget {
  final int id;
  final int color;
  const UnlockedTurtle({super.key, required this.id, required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("assets/images/turtles/swim/swim1.png"),
        id != 21
            ? Container()
            : Image.asset("assets/images/turtles/21_underlay.png"),
        id >= 0 && id < TURTLES.length
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                    TURTLE_COLORS[color].withOpacity(0.5), BlendMode.srcATop),
                child: Image.asset("assets/images/turtles/$id.png"))
            : Container(),
        id != 10
            ? Container()
            : Image.asset("assets/images/turtles/10_overlay.png"),
      ],
    );
  }
}
