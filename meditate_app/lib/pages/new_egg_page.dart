import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/components/shake_widget.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:animated_counter/animated_counter.dart';

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
    await Future.delayed(Duration(milliseconds: 400));
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
    return Scaffold(
        // backgroundColor: Colors.white,
        body: Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 200,
                child: ShakeWidget(
                    // 4. pass the GlobalKey as an argument
                    key: shakeKey,
                    // 5. configure the animation parameters
                    shakeCount: 3,
                    shakeOffset: 10,
                    shakeDuration: Duration(milliseconds: 500),
                    child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          shakeKey.currentState?.shake();
                        },
                        child: Image.asset("assets/egg.png")))),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
            ),
            Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("You found an egg!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )),
            Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Hatch it by meditating multiple days in a row.",
                  style: TextStyle(fontSize: 14)),
            )),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Get.offAll(AppPages());
              },
              child: Container(
                  color: Color.fromARGB(255, 16, 77, 127),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 100),
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
      ),
    ));
  }
}
