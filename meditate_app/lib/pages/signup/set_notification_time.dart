import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/pages/signup/find_us_widget.dart';

class SetNotificationTimePage extends StatefulWidget {
  const SetNotificationTimePage({super.key});

  @override
  State<SetNotificationTimePage> createState() =>
      _SetNotificationTimePageState();
}

class _SetNotificationTimePageState extends State<SetNotificationTimePage> {
  double _waterOpacity = 1.0; // Initial opacity for water fade-out animation
  double _opacity = 0.0; // Initial opacity for fade-in animation of options

  @override
  void initState() {
    super.initState();
    // Trigger fade-out of water animation and fade-in of options
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _waterOpacity = 0.3; // Start fading out the water animation
      });
    });
    // Fade in the options after water animation fades out
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _opacity = 1.0; // Start fading in the options
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff87CEEB),
              Color.fromARGB(255, 100, 162, 200),
              Color.fromARGB(255, 25, 142, 238),
              Color.fromARGB(255, 1, 62, 137),
            ],
          ))),
          Opacity(
            opacity: 0.3,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/ocean_background.jpeg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          // Water Animation with fade-out
          Hero(
            tag: "WaterAnimation",
            child: AnimatedOpacity(
              opacity: _waterOpacity,
              duration: const Duration(milliseconds: 1000),
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
              shape: BubbleShape.circle,
            ),
          ),
          Opacity(
            opacity: 0.4,
            child: Container(
              color: Colors.black54,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
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
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(milliseconds: 500),
                      child: const Text(
                        "It's hard to remember to meditate",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 25),
                      ),
                    )),
                // Fade-in animation for options
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
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
                            postHogService.logEvent("HOW_YOUTUBE", {});
                            SignupController controller = Get.find();
                            controller.page.value = -3;
                            controller.update();
                          },
                          child: const FindUsWidget(
                              text: "YouTube", selected: false)),
                      GestureDetector(
                          onTap: () {
                            PostHogService postHogService = Get.find();
                            postHogService.logEvent("HOW_APP_STORE", {});
                            SignupController controller = Get.find();
                            controller.page.value = -3;
                            controller.update();
                          },
                          child: const FindUsWidget(
                              text: "App Store", selected: false)),
                      GestureDetector(
                          onTap: () {
                            PostHogService postHogService = Get.find();
                            postHogService.logEvent("HOW_TIKTOK", {});
                            SignupController controller = Get.find();
                            controller.page.value = -3;
                            controller.update();
                          },
                          child: const FindUsWidget(
                              text: "TikTok", selected: false)),
                      GestureDetector(
                          onTap: () {
                            PostHogService postHogService = Get.find();
                            postHogService.logEvent("HOW_OTHER", {});
                            SignupController controller = Get.find();
                            controller.page.value = -3;
                            controller.update();
                          },
                          child: const FindUsWidget(
                              text: "Other", selected: false)),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
