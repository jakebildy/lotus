import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:meditate_app/pages/turtle_details_page.dart';
import 'package:meditate_app/services/appsflyer_service.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

class TurtleCard extends StatelessWidget {
  final int id;
  final bool unlocked;
  const TurtleCard({Key? key, required this.unlocked, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 110),
      onPressed: () {
        if (unlocked) {
          //Log the event to AppsFlyer
          AppsflyerService appsflyer = Get.find();
          appsflyer.logEvent("TURTLE_TAPPED", {});
          HapticFeedback.lightImpact();
          Get.to(TurtleDetailsPage(id: id), transition: Transition.downToUp);
        } else {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).clearSnackBars();
          //Log the event to AppsFlyer
          AppsflyerService appsflyer = Get.find();
          appsflyer.logEvent("LOCKED_TURTLE_TAPPED", {});
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
          child: unlocked
              ? Hero(
                  tag: "turtle-${id}",
                  child: Stack(
                    children: [
                      Image.asset("assets/turtles/0.png"),
                      id > 0 && id < TURTLES.length
                          ? Image.asset("assets/turtles/${id}.png")
                          : Container(),
                    ],
                  ))
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/turtles/locked.png"),
                    Text(
                      "?",
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )),
    );
  }
}
