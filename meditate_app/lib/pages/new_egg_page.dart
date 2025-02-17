import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/turtles.dart';

class NewEggPage extends StatefulWidget {
  const NewEggPage({Key? key}) : super(key: key);

  @override
  State<NewEggPage> createState() => _NewEggPageState();
}

class _NewEggPageState extends State<NewEggPage> with TickerProviderStateMixin {
  final shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void initState() {
    super.initState();
    shakeAfterASec();
  }

  bool isOnPage = true;

  Future<void> shakeAfterASec() async {
    await Future.delayed(const Duration(milliseconds: 400));
    shakeKey.currentState?.shake();
    HapticFeedback.lightImpact();

    while (isOnPage) {
      await Future.delayed(Duration(seconds: Random().nextInt(4) + 3));
      if (isOnPage) {
        shakeKey.currentState?.shake();
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  void dispose() {
    isOnPage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 200,
                  child: ShakeWidget(
                      // 4. pass the GlobalKey as an argument
                      key: shakeKey,
                      // 5. configure the animation parameters
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 500),
                      child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            shakeKey.currentState?.shake();
                          },
                          child: Stack(
                            children: [
                              Image.asset("assets/egg.png"),
                              (int.parse(user.user.value.eggTypes.last
                                          .split("-")[1]) ==
                                      18)
                                  ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          colors: [
                                            Colors.red.withOpacity(0.5),
                                            Colors.orange.withOpacity(0.5),
                                            Colors.yellow.withOpacity(0.5),
                                            Colors.green.withOpacity(0.5),
                                            Colors.blue.withOpacity(0.5),
                                            Colors.indigo.withOpacity(0.5),
                                            Colors.purple.withOpacity(0.5),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.centerRight,
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Image.asset(
                                        "assets/egg_spots.png",
                                        // height: 60,
                                      ),
                                    )
                                  : ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          TURTLE_COLORS[int.parse(user
                                                  .user.value.eggTypes.last
                                                  .split("-")[1])]
                                              .withOpacity(0.8),
                                          BlendMode.srcATop),
                                      child: Image.asset(
                                        "assets/egg_spots.png",
                                        // height: 60,
                                      )),
                            ],
                          )))),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("You found an egg!",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Hatch it by meditating multiple days in a row.",
                    style: TextStyle(fontSize: 14)),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  // If it's the first time, go to paywall page
                  SaveController save = Get.find();
                  setState(() {
                    isOnPage = false;
                  });
                  // if (save.hasShownPaywallPage.value == false &&
                  //     save.isSubscribedToPremium.value == false &&
                  //     user.user.value.totalMinutes < 40) {
                  //   Get.to(const SetGoalPage());
                  //   save.updateHasShownPaywallPage();
                  // } else {
                  Get.offAll(const AppPages());
                  // }
                },
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 16, 77, 127),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12.0, horizontal: 100),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}
