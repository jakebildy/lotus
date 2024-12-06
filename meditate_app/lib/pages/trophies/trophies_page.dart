import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:meditate_app/components/turtle_image.dart';
import 'package:meditate_app/pages/trophies/trophy_widget.dart';

class TrophyPage extends StatelessWidget {
  const TrophyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[900],
          title: const Text("Trophies"),
        ),
        backgroundColor: Colors.grey[900],
        body: ListView(
          children: const [
            TrophyWidget(
                title: "Into the Fire",
                description:
                    "Collect a Litback Turtle, a Nether Turtle and a Magma Turtle",
                xp: 40,
                turtles: [
                  [6, 2],
                  [7, 1],
                  [17, 4]
                ]),
            TrophyWidget(
                title: "Celestial Harmony",
                description:
                    "Collect a Sun Turtle, a Luna Turtle and a World Turtle",
                xp: 60,
                turtles: [
                  [8, 2],
                  [19, 0],
                  [20, 8]
                ])
          ],
        ));
  }
}
