import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/login/login.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

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
          image: AssetImage("assets/fire_joypixel.gif"),
          width: 100,
          height: 100,
        ),
        Text(
          "start a meditation streak",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Get streak freezes to save your streak if you miss a day!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 60),
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
                  controller.page.value = -1;
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
      ],
    );
  }
}
