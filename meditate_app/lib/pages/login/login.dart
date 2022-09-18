import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/bubbles/bubbles.dart';
import 'package:meditate_app/controllers/login_controller.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Container(
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
                    SizedBox(height: 40),

                    Center(
                      child: Text("Login",
                          style:
                              TextStyle(fontSize: 24, fontFamily: "Termina")),
                    ),
                    SizedBox(height: 60),

                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        // Email
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: controller.email,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
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
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        // Password
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: controller.password,
                          obscureText: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
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
                    SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.tealAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Colors.tealAccent)))),
                          onPressed: controller.login,
                          child: SizedBox(
                              width: 2000,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("Login",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ))),
                    ),
                    // Text("brands@fits.app", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
