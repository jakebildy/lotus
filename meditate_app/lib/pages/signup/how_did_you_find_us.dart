import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/get_subscription/get_subscription_page.dart';
import 'package:meditate_app/pages/signup/find_us_widget.dart';
import 'package:meditate_app/pages/signup/goal_widget.dart';
import 'package:meditate_app/services/posthog_service.dart';

class HowDidYouFindUsPage extends StatefulWidget {
  const HowDidYouFindUsPage({super.key});

  @override
  State<HowDidYouFindUsPage> createState() => _HowDidYouFindUsPageState();
}

class _HowDidYouFindUsPageState extends State<HowDidYouFindUsPage> {
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
                "How did you find us?",
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
            // const Padding(
            //   padding: EdgeInsets.all(14.0),
            //   child: Text(
            //     "Selecting a goal will help you stay motivated.",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            GestureDetector(
                onTap: () {
                  PostHogService postHogService = Get.find();
                  postHogService.logEvent("HOW_FRIEND_TOLD_ME", {});
                  SignupController controller = Get.find();
                  controller.page.value = -3;
                  controller.update();
                },
                child: const FindUsWidget(
                    text: "Friend told me", selected: false)),
            GestureDetector(
                onTap: () {
                  PostHogService postHogService = Get.find();
                  postHogService.logEvent("HOW_IG_FACEBOOK", {});
                  SignupController controller = Get.find();
                  controller.page.value = -3;
                  controller.update();
                },
                child: const FindUsWidget(
                    text: "Instagram/Facebook", selected: false)),
            GestureDetector(
                onTap: () {
                  PostHogService postHogService = Get.find();
                  postHogService.logEvent("HOW_TIKTOK", {});
                  SignupController controller = Get.find();
                  controller.page.value = -3;
                  controller.update();
                },
                child: const FindUsWidget(text: "TikTok", selected: false)),
            GestureDetector(
                onTap: () {
                  PostHogService postHogService = Get.find();
                  postHogService.logEvent("HOW_APP_STORE", {});
                  SignupController controller = Get.find();
                  controller.page.value = -3;
                  controller.update();
                },
                child: const FindUsWidget(text: "App Store", selected: false)),
            GestureDetector(
                onTap: () {
                  PostHogService postHogService = Get.find();
                  postHogService.logEvent("HOW_OTHER", {});
                  SignupController controller = Get.find();
                  controller.page.value = -3;
                  controller.update();
                },
                child: const FindUsWidget(text: "Other", selected: false)),
            const Spacer(),

            const SizedBox(height: 80),
          ],
        ),
      )
    ]));
  }
}
