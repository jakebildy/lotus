import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foil/foil.dart';
import 'package:get/get.dart';
import 'package:meditate_app/app_pages.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xl/xl.dart';
import 'new_egg_page.dart';

class LevelUpPage extends StatefulWidget {
  final bool foundEgg;

  const LevelUpPage({Key? key, required this.foundEgg}) : super(key: key);

  @override
  State<LevelUpPage> createState() => _LevelUpPageState();
}

class _LevelUpPageState extends State<LevelUpPage> {
  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();
    return Scaffold(
        // backgroundColor: Colors.white,
        body: Center(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: Container(
                        height: 190,
                        width: 150,
                        child: XL(layers: [
                          XLayer(
                              xRotation: 0.4,
                              yRotation: 0.4,
                              xOffset: 4,
                              yOffset: 4,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // hexagon

                                  Text(
                                    "⭐️",
                                    style: TextStyle(fontSize: 140),
                                  ),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Foil(
                                        child: Text(
                                      "⭐️",
                                      style: TextStyle(fontSize: 140),
                                    )),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.white12,
                                    highlightColor: Colors.white38,
                                    child: Text(
                                      "⭐️",
                                      style: TextStyle(fontSize: 140),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Text(
                                      (calculateLevel(
                                                  user.user.value.levelPoints) +
                                              12)
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 50,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 0.0),
                                            ),
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 0.0),
                                            ),
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(0, 0.0),
                                            ),
                                          ],
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightBlueAccent),
                                    ),
                                  )
                                ],
                              ))
                        ]),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("LEVEL UP",
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "You reached Level " +
                          calculateLevel(user.user.value.levelPoints)
                              .toString() +
                          "!",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.foundEgg) {
                      Get.offAll(const NewEggPage());
                    } else {
                      Get.offAll(const AppPages());
                    }
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 16, 77, 127),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      // color: const Color.fromARGB(255, 16, 77, 127),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 100),
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
        ],
      ),
    ));
  }
}
