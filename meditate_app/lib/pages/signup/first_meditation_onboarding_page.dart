import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/countdown_controller.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/meditation_guide_page.dart';

class FirstMeditationOnboardingPage extends StatelessWidget {
  const FirstMeditationOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find();
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "let's meditate for just 1 minute",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const Image(
              image: AssetImage("assets/app_icon.jpg"),
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
              "Are you ready to become more balanced?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Colors.white, width: 2)))),
                  onPressed: () {
                    CountdownController countdownController = Get.find();
                    countdownController.totalSeconds.value =
                        const Duration(minutes: 1).inSeconds;
                    countdownController.update();
                    SaveController save = Get.find();
                    save.saveValue("GUIDE_SHOWN", "TRUE");
                    Get.to(
                        MeditationGuide(
                            time: const Duration(minutes: 1),
                            ambience: save.selectedAmbience.value),
                        transition: Transition.circularReveal,
                        duration: const Duration(seconds: 1));
                  },
                  child: const SizedBox(
                      width: 2000,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text("Let's do it",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ))),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Get.offAll(const AppPages());
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "No, I'm not ready",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      )
    ]));
  }
}
