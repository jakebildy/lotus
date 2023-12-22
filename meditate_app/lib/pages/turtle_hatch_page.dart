import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/pages/new_gems_page.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:in_app_review/in_app_review.dart';

class TurtleHatchPage extends StatefulWidget {
  final int gemsAmount;
  final bool foundEgg;
  final int turtleToHatch;
  final int turtleColorToHatch;

  const TurtleHatchPage(
      {Key? key,
      required this.gemsAmount,
      required this.foundEgg,
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
        // backgroundColor: Colors.white,
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
                        : Image.asset("assets/images/turtles/10_overlay.png"),
                  ],
                )),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Your egg hatched!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              if (save.hasReviewed.value == false) {
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                  save.updateHasReviewed();
                }
              }
              Get.offAll(NewGemsPage(
                gemsAmount: widget.gemsAmount,
                foundEgg: widget.foundEgg,
              ));
            },
            child: Container(
                color: const Color.fromARGB(255, 16, 77, 127),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 100),
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
