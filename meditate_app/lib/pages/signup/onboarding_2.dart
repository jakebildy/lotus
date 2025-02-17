import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/services/posthog_service.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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
        const Text(
          "Start a meditation streak",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        const Image(
          image: AssetImage("assets/fire.gif"),
          width: 100,
          height: 100,
        ),
        const Padding(
          padding: EdgeInsets.all(14.0),
          child: Text(
            "Get streak freezes to save your streak if you miss a day!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
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
                  posthog.logEvent("SECOND_ONBOARDING_CONTINUE_PRESSED", {});
                  controller.page.value = -1;
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
