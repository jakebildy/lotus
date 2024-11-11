import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/util.dart';
import 'package:shimmer/shimmer.dart';

class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 14,
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    border: const Border.fromBorderSide(
                        BorderSide(color: Colors.transparent, width: 2)),
                  ),
                ),
                40 > 100
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: calculateRemainingLevelPercentage(
                                  userController.user.value.levelPoints) *
                              (MediaQuery.of(context).size.width - 80),
                          height: 10,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                // Colors.blue,
                                // Colors.cyan,
                                Colors.teal,
                                Colors.green
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                40 > 100
                    ? Container()
                    : Shimmer.fromColors(
                        baseColor: Colors.white12,
                        highlightColor: Colors.white24,
                        period: const Duration(milliseconds: 3000),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            width: calculateRemainingLevelPercentage(
                                    userController.user.value.levelPoints) *
                                (MediaQuery.of(context).size.width - 80),
                            height: 10,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  // Colors.blue,
                                  // Colors.cyan,
                                  Colors.green,
                                  Colors.lightGreen
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
