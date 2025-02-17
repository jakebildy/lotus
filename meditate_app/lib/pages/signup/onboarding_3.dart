import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:meditate_app/util/turtles.dart';

class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3>
    with TickerProviderStateMixin {
  final List<AnimationController> fadeControllers = [];
  final List<Animation<double>> fadeAnimations = [];
  final int numEggs = 6; // We'll show 6 eggs in a grid

  @override
  void initState() {
    super.initState();

    // Create fade controllers and animations for each egg
    for (int i = 0; i < numEggs; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.2,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));

      fadeControllers.add(controller);
      fadeAnimations.add(animation);

      // Start the animations with different delays
      Future.delayed(Duration(milliseconds: 500 * i), () {
        startFading(i);
      });
    }
  }

  void startFading(int index) async {
    while (true) {
      await fadeControllers[index].forward();
      await fadeControllers[index].reverse();
      await Future.delayed(
          Duration(milliseconds: Random().nextInt(1000) + 500));
    }
  }

  @override
  void dispose() {
    // isOnPage = false;
    for (var controller in fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildEgg(int index) {
    return AnimatedBuilder(
      animation: fadeAnimations[index],
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimations[index].value,
          child: Stack(
            children: [
              Image.asset("assets/egg.png"),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  TURTLE_COLORS[index % TURTLE_COLORS.length].withOpacity(0.8),
                  BlendMode.srcATop,
                ),
                child: Image.asset(
                  "assets/egg_spots.png",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
        ),
        const Text(
          "Find eggs by meditating",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Hatch them by meditating three days!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 30),
        // Replace the single egg with a grid of eggs
        SizedBox(
          height: 300,
          child: GridView.count(
            crossAxisCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(numEggs, (index) => buildEgg(index)),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
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
                            side: const BorderSide(
                                color: Colors.white, width: 2)))),
                onPressed: () {
                  PostHogService posthog = Get.find();
                  posthog.logEvent("THIRD_ONBOARDING_CONTINUE_PRESSED", {});
                  controller.page.value = 0;
                  controller.update();
                },
                child: const SizedBox(
                    width: 2000,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
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
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Back",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
