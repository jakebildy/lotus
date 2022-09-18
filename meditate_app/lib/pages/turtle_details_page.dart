import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/components/streak_chart.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/stats_page.dart';
import 'package:meditate_app/pages/streak_count_page.dart';
import 'package:meditate_app/util/turtles.dart';

class TurtleDetailsPage extends StatefulWidget {
  final int id;
  const TurtleDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<TurtleDetailsPage> createState() => _TurtleDetailsPageState();
}

class _TurtleDetailsPageState extends State<TurtleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    SaveController saveController = Get.find();
    bool isDarkMode = true;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Turtle"),
      ),
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff87CEEB),
            Color.fromARGB(255, 100, 162, 200),
            Color.fromARGB(255, 25, 142, 238),
            Color.fromARGB(255, 1, 62, 137),
          ],
        )),
        child: Stack(
          children: [
            Positioned.fill(
                child: FloatingBubbles.alwaysRepeating(
              noOfBubbles: 20,
              colorsOfBubbles: [
                Colors.white.withAlpha(30),
              ],
              sizeFactor: 0.03,
              opacity: 70,
              paintingStyle: PaintingStyle.fill,
              strokeWidth: 1,
              shape: BubbleShape
                  .circle, // circle is the default. No need to explicitly mention if its a circle.
            )),
            ListView(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.white24,
                  height: 300,
                  child: Hero(
                      tag: "turtle-${widget.id}",
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset("assets/turtles/0.png"),
                          widget.id > 0 && widget.id < TURTLES.length
                              ? Image.asset("assets/turtles/${widget.id}.png")
                              : Container(),
                        ],
                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                      color: Colors.grey[850],
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              TURTLES[widget.id].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      TURTLES[widget.id].rarity == Rarity.COMMON
                                          ? "Common"
                                          : TURTLES[widget.id].rarity ==
                                                  Rarity.RARE
                                              ? "Rare"
                                              : "Legendary",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: TURTLES[widget.id].rarity ==
                                                Rarity.COMMON
                                            ? Colors.greenAccent
                                            : TURTLES[widget.id].rarity ==
                                                    Rarity.RARE
                                                ? Colors.cyan
                                                : Colors.yellow,
                                      ),
                                    ),
                                    Text(
                                      "Rarity",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${saveController.unlockedTurtles[widget.id]}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Text(
                                      "Number Found",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      TURTLES[widget.id].tier == Tier.ORANGE
                                          ? "Hatchling"
                                          : TURTLES[widget.id].tier ==
                                                  Tier.YELLOW
                                              ? "Champion"
                                              : TURTLES[widget.id].tier ==
                                                      Tier.BLUE
                                                  ? "Expert"
                                                  : "Turtlemaster",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Text(
                                      "Level",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${TURTLES[widget.id].name + "s"} are ${TURTLES[widget.id].rarity == Rarity.COMMON ? "commonly" : TURTLES[widget.id].rarity == Rarity.RARE ? "rarely" : "extremely rarely"} found on Lotus Island. \n\nTheir eggs can be found by those at the ${TURTLES[widget.id].tier == Tier.ORANGE ? "Hatchling" : TURTLES[widget.id].tier == Tier.YELLOW ? "Champion" : TURTLES[widget.id].tier == Tier.BLUE ? "Expert" : "Turtlemaster"} level or higher.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(StatsPage());
                            },
                            child: Text(
                              "View my Tier",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 400,
                          )
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
