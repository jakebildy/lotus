import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/login/login.dart';
import 'package:meditate_app/pages/signup/onboarding_0.dart';
import 'package:meditate_app/pages/signup/onboarding_1.dart';
import 'package:meditate_app/pages/signup/onboarding_2.dart';
import 'package:meditate_app/pages/signup/onboarding_3.dart';
import 'package:meditate_app/services/posthog_service.dart';

class Signup extends StatefulWidget {
  final bool? noOptions;
  final bool? isPopup;

  const Signup({super.key, this.noOptions, this.isPopup});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // init state
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      body: Obx(
        () => Container(
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
                    controller.page.value < -3
                        ? const Onboarding0()
                        : controller.page.value == -3
                            ? const Onboarding1()
                            : controller.page.value == -2
                                ? const Onboarding2()
                                : controller.page.value == -1
                                    ? const Onboarding3()
                                    : ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          const SizedBox(height: 20),
                                          Center(
                                              child: SizedBox(
                                                  height: 100,
                                                  child: Hero(
                                                      tag: "Logo",
                                                      child: Image.asset(
                                                          "assets/logo.png")))),
                                          Center(
                                            child: Text(
                                              controller.page.value == 0
                                                  ? "What's your name?"
                                                  : "Hi " +
                                                      controller
                                                          .usernameText.value +
                                                      " 👋 \nReady to start?",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          const SizedBox(height: 30),
                                          controller.page.value == 1
                                              ? Container()
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          widget.isPopup == true
                                                              ? 0
                                                              : 50),
                                                  // User Name
                                                  child: TextField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-zA-Z0-9_]")),
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        controller.username,
                                                    onChanged: (value) {
                                                      controller.usernameText
                                                          .value = value;
                                                      controller.update();
                                                    },
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 10,
                                                              horizontal: 40),
                                                      hintText:
                                                          "Type your username...",
                                                      fillColor:
                                                          Colors.transparent,
                                                      hintStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      filled: true,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                    ),
                                                  )),
                                          const SizedBox(height: 30),
                                          controller.page.value == 0
                                              ? Container()
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          widget.isPopup == true
                                                              ? 0
                                                              : 50),
                                                  // Email
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        controller.email,
                                                    onChanged: (value) {
                                                      controller.emailText
                                                          .value = value;
                                                      controller.update();
                                                    },
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 10,
                                                              horizontal: 40),
                                                      hintText: "Email",
                                                      fillColor:
                                                          Colors.transparent,
                                                      hintStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      filled: true,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                    ),
                                                  )),
                                          const SizedBox(height: 30),
                                          controller.page.value == 0
                                              ? Container()
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          widget.isPopup == true
                                                              ? 0
                                                              : 50),
                                                  // Password
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        controller.password,
                                                    onChanged: (value) {
                                                      controller.passwordText
                                                          .value = value;
                                                      controller.update();
                                                    },
                                                    obscureText: true,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      alignLabelWithHint: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 10,
                                                              horizontal: 40),
                                                      hintText: "Password",
                                                      fillColor:
                                                          Colors.transparent,
                                                      hintStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      filled: true,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                    ),
                                                  )),
                                          const SizedBox(height: 60),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    widget.isPopup == true
                                                        ? 0
                                                        : 50),
                                            child: Hero(
                                              tag: "LoginButton",
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      elevation: MaterialStateProperty
                                                          .all<double>(0),
                                                      backgroundColor: MaterialStateProperty.all<Color>(controller
                                                                          .page
                                                                          .value ==
                                                                      0 &&
                                                                  controller
                                                                      .usernameText
                                                                      .value
                                                                      .isNotEmpty ||
                                                              controller.page.value == 1 &&
                                                                  controller
                                                                      .emailText
                                                                      .value
                                                                      .isNotEmpty &&
                                                                  controller
                                                                      .passwordText
                                                                      .value
                                                                      .isNotEmpty
                                                          ? Colors.lightBlue
                                                          : Colors.white12),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(width: 2, color: controller.page.value == 0 && controller.usernameText.value.isNotEmpty || controller.page.value == 1 && controller.emailText.value.isNotEmpty && controller.passwordText.value.isNotEmpty ? Colors.white : Colors.white12)))),
                                                  onPressed: () {
                                                    if (controller.page.value ==
                                                        0) {
                                                      setState(() {
                                                        controller.page.value =
                                                            1;
                                                        controller.update();
                                                      });
                                                    } else {
                                                      PostHogService posthog =
                                                          Get.find();
                                                      posthog.logEvent(
                                                          "SIGNUP_PRESSED", {});
                                                      controller.signup();
                                                    }
                                                  },
                                                  child: SizedBox(
                                                      width: 2000,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                            controller.page.value == 0
                                                                ? "Continue"
                                                                : "Sign Up",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: controller.page.value == 0 &&
                                                                            controller
                                                                                .usernameText.value.isNotEmpty ||
                                                                        controller.page.value == 1 &&
                                                                            controller
                                                                                .emailText.value.isNotEmpty &&
                                                                            controller
                                                                                .passwordText.value.isNotEmpty
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ))),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () {
                                              if (controller.page.value == 0) {
                                                Get.to(const Login());
                                              } else {
                                                setState(() {
                                                  controller.page.value = 0;
                                                  controller.update();
                                                });
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                controller.page.value == 1
                                                    ? "Go Back"
                                                    : "I already have an account",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${controller.signupWarningMessage}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
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
