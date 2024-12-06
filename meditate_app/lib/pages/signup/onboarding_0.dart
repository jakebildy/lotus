import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/login/login.dart';
import 'package:meditate_app/services/posthog_service.dart';

class Onboarding0 extends StatelessWidget {
  const Onboarding0({super.key});

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
        Image(
          image: AssetImage("assets/logo.png"),
          width: 100,
          height: 100,
        ),
        Text(
          "shellevate",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        Text(
          "Easily make meditation a habit.",
          style: TextStyle(fontSize: 16),
        ),
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
                  controller.page.value = -3;
                  controller.update();

                  PostHogService posthog = Get.find();
                  posthog.logEvent("BEGIN_ONBOARDING_CONTINUE_PRESSED", {});
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
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Get.to(const Login());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "I already have an account",
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
