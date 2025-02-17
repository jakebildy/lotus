import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/signup_controller.dart';
import 'package:meditate_app/pages/countdown/countdown_box_decoration.dart';
import 'package:meditate_app/pages/login/login.dart';
import 'package:meditate_app/services/posthog_service.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Onboarding0 extends StatefulWidget {
  const Onboarding0({super.key});

  @override
  _Onboarding0State createState() => _Onboarding0State();
}

class _Onboarding0State extends State<Onboarding0> {
  bool _isSlidingUp = false;
  bool _fadeInWaterAnimation = false;

  @override
  Widget build(BuildContext context) {
    SignupController controller = Get.find();
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: _isSlidingUp ? -50 : 0,
          left: 0,
          right: 0,
          child: Stack(
            children: [
              Container(
                height: 440,
                width: MediaQuery.of(context).size.width,
                decoration: getBoxDecorationForAmbience("Night"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: SizedBox(
                  height: 340,
                  child: WaveWidget(
                    config: CustomConfig(
                      colors: [
                        const Color.fromRGBO(0, 105, 147, 0.22),
                        const Color(0x3300BBF9),
                      ],
                      durations: [
                        10000,
                        12000,
                      ],
                      heightPercentages: [
                        0.54,
                        0.55,
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                    size: const Size(double.infinity, double.infinity),
                    waveAmplitude: 0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 440, 0, 0),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF709bcc),
                        Color(0x00358fb9),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Image.asset("assets/lotus2.png"),
              ),
            ],
          ),
        ),
        // Water Animation Fade-in
        Hero(
          tag: "WaterAnimation",
          child: AnimatedOpacity(
            opacity: _fadeInWaterAnimation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              "assets/images/game/water_2.gif",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        AnimatedOpacity(
            opacity: _fadeInWaterAnimation ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                ),
                const Text(
                  "Welcome to",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const Text(
                  "shellevate",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Let's personalize your experience",
                  style: TextStyle(fontSize: 16),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side:
                                const BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isSlidingUp = true;
                        });
                        // Wait for slide-up animation to complete
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            _fadeInWaterAnimation = true;
                          });
                          // Wait for fade-in animation to complete
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            controller.page.value = -4;
                            controller.update();
                            PostHogService posthog = Get.find();
                            posthog.logEvent(
                                "BEGIN_ONBOARDING_CONTINUE_PRESSED", {});
                          });
                        });
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            )),
      ],
    );
  }
}
