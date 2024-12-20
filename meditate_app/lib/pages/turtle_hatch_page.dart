import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/new_gems_page.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:in_app_review/in_app_review.dart';

class TurtleHatchPage extends StatefulWidget {
  final int gemsAmount;
  final bool foundEgg;
  final bool levelUp;
  final int turtleToHatch;
  final int turtleColorToHatch;

  const TurtleHatchPage(
      {Key? key,
      required this.gemsAmount,
      required this.foundEgg,
      required this.levelUp,
      required this.turtleToHatch,
      required this.turtleColorToHatch})
      : super(key: key);

  @override
  State<TurtleHatchPage> createState() => _TurtleHatchPageState();
}

class _TurtleHatchPageState extends State<TurtleHatchPage>
    with TickerProviderStateMixin {
  double opacity = 0;

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    increaseCount();
  }

  Future<void> increaseCount() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opacity = 1;
    });
  }

  SaveController save = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: opacity,
                child: SizedBox(
                    height: 300,
                    width: 409,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/images/turtles/swim/swim1.png"),
                        widget.turtleToHatch >= 0 &&
                                widget.turtleToHatch < TURTLES.length
                            ? ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    TURTLE_COLORS[widget.turtleColorToHatch]
                                        .withOpacity(0.5),
                                    BlendMode.srcATop),
                                child: Image.asset(
                                    "assets/images/turtles/${widget.turtleToHatch}.png"))
                            : Container(),
                        widget.turtleToHatch != 10
                            ? Container()
                            : Image.asset(
                                "assets/images/turtles/10_overlay.png"),
                        widget.turtleToHatch != 23
                            ? Container()
                            : Image.asset(
                                "assets/images/turtles/23_overlay.png"),
                      ],
                    )),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Your egg hatched!",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "You found a ${TURTLE_COLORS_NAME[widget.turtleColorToHatch]} ${TURTLES[widget.turtleToHatch].name}.",
                    style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () async {
                  Get.offAll(NewGemsPage(
                    gemsAmount: widget.gemsAmount,
                    foundEgg: widget.foundEgg,
                    levelUp: widget.levelUp,
                  ));

                  SaveController save = Get.find();
                  if (save.hasReviewed.value == false) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 47, 111, 129),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            title: const Text(
                              "Help Shellevate Grow",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    "Hey there! I’m one person creating this entire app. \n\nIf you like it, it would mean a lot if you could take 10 seconds to leave a rating!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        PostHogService posthog = Get.find();
                                        posthog
                                            .logEvent("REVIEW_SURE_TAPPED", {});
                                        final InAppReview inAppReview =
                                            InAppReview.instance;

                                        if (await inAppReview.isAvailable()) {
                                          inAppReview.requestReview();
                                          save.updateHasReviewed();
                                        }
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            color: Colors.cyan,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Sure ❤️",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          save.updateHasReviewed();
                                          PostHogService posthog = Get.find();
                                          posthog.logEvent(
                                              "REVIEW_NO_THANKS_TAPPED", {});
                                        },
                                        child: const Text("No Thanks"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                      },
                    );
                  }
                },
                child: Container(
                    color: const Color.fromARGB(255, 16, 77, 127),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 100),
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
        ));
  }
}
