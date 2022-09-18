import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/auth_controller.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/login/login.dart';

class Signup extends StatelessWidget {
  final bool? noOptions;
  final bool? isPopup;
  const Signup({Key? key, this.noOptions, this.isPopup})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      body: Obx(
        () => Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
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
              padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
              child: Center(
                child: Stack(
                  children: [
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
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 20),
                        Center(
                            child: Container(
                                height: 100,
                                child: Hero(
                                    tag: "Logo",
                                    child: Image.asset("assets/logo.png")))),
                        Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: this.isPopup == true ? 0 : 50),
                            // First Name
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: controller.fullName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                hintText: "Display Name",
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                        SizedBox(height: 30),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: this.isPopup == true ? 0 : 50),
                            // User Name
                            child: TextField(
                              inputFormatters: [
                                new FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z0-9_]")),
                              ],
                              textAlign: TextAlign.center,
                              controller: controller.username,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                hintText: "Username",
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                        SizedBox(height: 30),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: this.isPopup == true ? 0 : 50),
                            // Email
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: controller.email,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                hintText: "Email",
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                        SizedBox(height: 30),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: this.isPopup == true ? 0 : 50),
                            // Password
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: controller.password,
                              obscureText: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40),
                                hintText: "Password",
                                fillColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                        SizedBox(height: 60),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: this.isPopup == true ? 0 : 50),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.all<double>(0),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.tealAccent),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(
                                              color: Colors.tealAccent)))),
                              onPressed: controller.signup,
                              child: SizedBox(
                                  width: 2000,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text("Sign Up",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                  ))),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Get.to(Login());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "I already have an account",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${controller.signupWarningMessage}",
                            style: TextStyle(
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
