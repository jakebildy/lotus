import 'package:flutter/material.dart';
import 'package:meditate_app/util/turtles.dart';

class LockedTurtle extends StatelessWidget {
  final int id;
  final int colorId;
  const LockedTurtle({super.key, required this.id, required this.colorId});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.3,
      child: Stack(
        children: [
          Image.asset("assets/images/turtles/swim/swim1.png"),
          id != 21
              ? Container()
              : Image.asset("assets/images/turtles/21_underlay.png"),
          id >= 0 && id < TURTLES.length
              ? (colorId == 18
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
                          TURTLE_COLORS[colorId].withOpacity(0.5),
                          BlendMode.srcATop),
                      child: Image.asset("assets/images/turtles/$id.png"),
                    ))
              : Container(),
          id != 10
              ? Container()
              : Image.asset("assets/images/turtles/10_overlay.png"),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.lock),
          ),
        ],
      ),
    );
  }
}
