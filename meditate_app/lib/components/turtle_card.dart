import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/locked_turtle.dart';
import 'package:meditate_app/pages/turtle_category_page.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';
import 'package:shimmer/shimmer.dart';

class TurtleCard extends StatelessWidget {
  final int id;
  final bool unlocked;
  final int color;
  final int quantity;
  const TurtleCard(
      {Key? key,
      required this.unlocked,
      required this.id,
      required this.color,
      required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 110),
      onPressed: () {
        if (unlocked) {
          HapticFeedback.lightImpact();
          Get.to(TurtleDetailsPage(id: id, color: color),
              transition: Transition.downToUp);
        } else {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              key: UniqueKey(),
              backgroundColor: tierColor(TURTLES[id].tier),
              content: Text(
                "This turtle can be found by ${tierReadablePlural(TURTLES[id].tier)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              )));
        }
      },
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          unlocked
              ? Hero(
                  tag: "turtle-${id}",
                  child: Stack(
                    children: [
                      Image.asset("assets/images/turtles/swim/swim1.png"),
                      id >= 0 && id < TURTLES.length
                          ? ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  TURTLE_COLORS[color].withOpacity(0.5),
                                  BlendMode.srcATop),
                              child: Image.asset(
                                  "assets/images/turtles/${id}.png"))
                          : Container(),
                      id != 10
                          ? Container()
                          : Image.asset("assets/images/turtles/10_overlay.png"),
                    ],
                  ))
              : LockedTurtle(id: id),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((TURTLE_COLORS_NAME[color] + " " + TURTLES[id].name),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Text("${quantity} found",
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              quantity > 0 ? Colors.tealAccent : Colors.grey))
                ],
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios),
          SizedBox(
            width: 10,
          )
        ],
      )),
    );
  }
}
