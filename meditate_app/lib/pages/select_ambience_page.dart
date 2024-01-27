import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/components/premium_container.dart';
import 'package:meditate_app/components/turtle_card.dart';
import 'package:meditate_app/controllers/save_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/pages/begin_meditation_page.dart';
import 'package:meditate_app/util/ambiences.dart';
import 'package:meditate_app/util/turtles.dart';

import '../app_pages.dart';

class SelectAmbiencePage extends StatelessWidget {
  const SelectAmbiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    SaveController save = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Ambience"),
      ),
      body: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: List.generate(AMBIENCES.length, (index) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  save.updateSelectedAmbience(AMBIENCES[index].name);
                  Get.offAll(const AppPages());
                },
                child: Card(
                    child: (Column(
                  children: [
                    Image.asset(
                      AMBIENCES[index].image,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                      child: Text(
                        AMBIENCES[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: save.selectedAmbience.value ==
                                    AMBIENCES[index].name
                                ? Colors.tealAccent
                                : Colors.white),
                      ),
                    ),
                    AMBIENCES[index].premium
                        ? const SizedBox(width: 80, child: PremiumContainer())
                        : const SizedBox(
                            width: 80,
                            height: 30,
                          )
                  ],
                ))),
              ),
            );
          })),
    );
  }
}
