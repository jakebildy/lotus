import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/egg_card.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/login/login.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';

class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  final shakeKey = GlobalKey<ShakeWidgetState>();
  @override
  void initState() {
    super.initState();
    shakeAfterASec();
  }

  bool isOnPage = true;

  Future<void> shakeAfterASec() async {
    await Future.delayed(const Duration(milliseconds: 400));
    shakeKey.currentState?.shake();
    HapticFeedback.lightImpact();

    while (isOnPage) {
      await Future.delayed(Duration(seconds: Random().nextInt(4) + 3));
      if (isOnPage) {
        shakeKey.currentState?.shake();
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 130,
          width: MediaQuery.of(context).size.width,
        ),
        Text(
          "sometimes you'll find eggs",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Hatch them by meditating three days!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 60),
        SizedBox(
            height: 200,
            child: ShakeWidget(
                // 4. pass the GlobalKey as an argument
                key: shakeKey,
                // 5. configure the animation parameters
                shakeCount: 3,
                shakeOffset: 10,
                shakeDuration: const Duration(milliseconds: 500),
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      shakeKey.currentState?.shake();
                    },
                    child: Stack(
                      children: [
                        Image.asset("assets/egg.png"),
                        ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                TURTLE_COLORS[3].withOpacity(0.8),
                                BlendMode.srcATop),
                            child: Image.asset(
                              "assets/egg_spots.png",
                              // height: 60,
                            )),
                      ],
                    )))),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Hero(
            tag: "LoginButton",
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightBlue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.white, width: 2)))),
                onPressed: () {
                  PostHogService posthog = Get.find();
                  posthog.logEvent("THIRD_ONBOARDING_CONTINUE_PRESSED", {});
                  controller.page.value = 0;
                  controller.update();
                },
                child: SizedBox(
                    width: 2000,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ))),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            controller.page.value = -3;
            controller.update();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Back",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
