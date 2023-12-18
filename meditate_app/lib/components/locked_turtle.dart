import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:meditate_app/util/turtles.dart';

class LockedTurtle extends StatelessWidget {
  final int id;
  final int colorId;
  const LockedTurtle({super.key, required this.id, required this.colorId});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: Stack(
        children: [
          Image.asset("assets/images/turtles/swim/swim1.png"),
          id >= 0 && id < TURTLES.length
              ? ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      TURTLE_COLORS[colorId == -1
                              ? id % TURTLE_COLORS.length
                              : colorId]
                          .withOpacity(0.5),
                      BlendMode.srcATop),
                  child: Image.asset("assets/images/turtles/${id}.png"))
              : Container(),
          id != 10
              ? Container()
              : Image.asset("assets/images/turtles/10_overlay.png"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.lock),
          ),
        ],
      ),
    );
  }
}
