import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/pages/get_subscription/get_subscription_page.dart';
import 'package:meditate_app/pages/signup/goal_widget.dart';
import 'package:meditate_app/services/posthog_service.dart';

class SetGoalPage extends StatefulWidget {
  const SetGoalPage({super.key});

  @override
  State<SetGoalPage> createState() => _SetGoalPageState();
}

class _SetGoalPageState extends State<SetGoalPage> {
  int selectedGoal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Opacity(
        opacity: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(0),
          //  padding: const EdgeInsets.fromLTRB(20,20,20,38),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/ocean_background.jpeg",
                  fit: BoxFit.fill,
                )),
          ),
        ),
      ),
      Hero(
        tag: "WaterAnimation",
        child: Opacity(
          opacity: 0.3,
          child: Image.asset(
            "assets/images/game/water_2.gif",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
      ),
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
      Container(
        color: Colors.black54,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Set your goal",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // const Image(
            //   image: AssetImage("assets/set_goal.webp"),
            //   width: 100,
            //   height: 100,
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                "Selecting a goal will help you stay motivated.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGoal = 0;
                  });
                },
                child: GoalWidget(
                    text: "Meditate for 3 days", selected: selectedGoal == 0)),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGoal = 1;
                  });
                },
                child: GoalWidget(
                    text: "Meditate for 1 week", selected: selectedGoal == 1)),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGoal = 2;
                  });
                },
                child: GoalWidget(
                    text: "Meditate for 1 month", selected: selectedGoal == 2)),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGoal = 3;
                  });
                },
                child: GoalWidget(
                    text: "Meditate for 1 year", selected: selectedGoal == 3)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Hero(
                tag: "ReadyButton",
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.white, width: 2)))),
                    onPressed: () {
                      PostHogService posthog = Get.find();
                      posthog.logEvent("SELECTED_GOAL", {"goal": selectedGoal});
                      Get.to(const GetSubscriptionPage());
                    },
                    child: const SizedBox(
                        width: 2000,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("I'm Committed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ))),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      )
    ]));
  }
}
