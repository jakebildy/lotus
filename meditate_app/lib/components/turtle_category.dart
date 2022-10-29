import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/pages/turtle_category_page.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

class TurtleCategory extends StatelessWidget {
  final int id;
  final bool unlocked;
  const TurtleCategory({Key? key, required this.unlocked, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 110),
      onPressed: () {
        if (unlocked) {
          HapticFeedback.lightImpact();
          Get.to(TurtleCategoryPage(id: id), transition: Transition.downToUp);
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
                                  TURTLE_COLORS[2].withOpacity(0.4),
                                  BlendMode.srcATop),
                              child: Image.asset(
                                  "assets/images/turtles/${id}.png"))
                          : Container(),
                    ],
                  ))
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/turtles/locked.png"),
                    Text(
                      "?",
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((TURTLES[id].name.split(" ")[0]),
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text("${unlocked ? '1' : '0'} of ${TURTLE_COLORS.length}",
                    style: TextStyle(fontSize: 14))
              ],
            ),
          ),
          SizedBox(
            width: 60,
          ),
          Text("14%", style: TextStyle(fontSize: 14, color: Colors.tealAccent)),
          Icon(Icons.arrow_forward_ios)
        ],
      )),
    );
  }
}
