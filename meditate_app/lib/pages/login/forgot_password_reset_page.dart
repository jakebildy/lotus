import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/login_controller.dart';

import 'package:meditate_app/api/index.dart' as api;

class ForgotPasswordResetPage extends StatelessWidget {
  const ForgotPasswordResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Obx(
      () => Scaffold(
        body: Container(
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
            )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Center(
                child: Stack(
                  children: [
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
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 20),
                        Center(
                            child: SizedBox(
                                height: 100,
                                child: Hero(
                                    tag: "Logo",
                                    child: Image.asset("assets/logo.png")))),
                        const Center(
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Enter the code you recieved to your email, and your new password.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            // Code
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: controller.resetCode,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                hintText: "Code",
                                fillColor: Colors.white,
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                        const SizedBox(height: 30),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            // Code
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: controller.password,
                              obscureText: true,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                hintText: "New Password",
                                fillColor: Colors.white,
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            controller.resetMessage.value,
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 70),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Hero(
                            tag: "SendEmailButton",
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.lightBlue),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                width: 2,
                                                color: Colors.white)))),
                                onPressed: () async {
                                  await api.user.resetPassword(
                                      controller.email.text,
                                      controller.password.text,
                                      controller.resetCode.text);

                                  controller.login();
                                },
                                child: const SizedBox(
                                    width: 2000,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text("Change Password",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ))),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Send another email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
