import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/level_progress_bar.dart';
import 'package:meditate_app/components/turtle_image.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/trophies/collections.dart';
import 'package:meditate_app/pages/trophies/trophy_widget.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

class TrophyPage extends StatelessWidget {
  const TrophyPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserController user = Get.find();

    return Obx(
      () => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[900],
            title: const Text("Collections"),
          ),
          backgroundColor: Colors.grey[900],
          bottomNavigationBar: SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              Text(
                "Level " +
                    calculateLevel(user.user.value.levelPoints, user.user.value)
                        .toString() +
                    " (${user.user.value.levelPoints + calculateTotalXPFromCollections()} XP)",
                style: const TextStyle(color: Colors.white),
              ),
              const LevelProgressBar(),
            ],
          )),
          body: ListView(
            children: [
              ...COLLECTIONS
                  .map((collection) => TrophyWidget(
                        title: collection.title,
                        xp: collection.xp,
                        turtles: collection.turtles,
                      ))
                  .toList(),
            ],
          )),
    );
  }
}
