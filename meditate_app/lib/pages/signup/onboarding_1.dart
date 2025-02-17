import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/countdown_demo_page.dart';
import 'package:meditate_app/pages/login/login.dart';
import 'package:meditate_app/services/posthog_service.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find();
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black45,
          width: MediaQuery.of(context).size.width,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: MediaQuery.of(context).size.width,
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "Meditation made into a game, so you can build a habit",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: Image(
            //     image: AssetImage("assets/app_icon.jpg"),
            //     width: 100,
            //     height: 100,
            //   ),
            // ),
            // demo page

            // Padding(
            //   padding: const EdgeInsets.all(14.0),
            //   child: Text(
            //     "Shellevate makes meditation into a game to help you build a habit.",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color: Colors.white, width: 2)))),
                    onPressed: () {
                      controller.page.value = -2;
                      controller.update();

                      PostHogService posthog = Get.find();
                      posthog.logEvent("FIRST_ONBOARDING_CONTINUE_PRESSED", {});
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.to(const Login());
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "I already have an account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
        Transform.scale(
          scale: 0.6,
          child: SizedBox(
            height: 600,
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: const CountdownDemoPage(
                ambience: "Rain",
                breathwork: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
