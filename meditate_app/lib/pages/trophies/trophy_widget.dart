import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:meditate_app/components/turtle_image.dart';

class TrophyWidget extends StatelessWidget {
  final String title;
  final String description;
  final int xp;
  final List<List<int>> turtles;
  const TrophyWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.xp,
      required this.turtles});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            // round border
            decoration: BoxDecoration(
                color: Colors.grey[800],
                border: Border.all(color: Colors.grey[700]!),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Text(
                          "+$xp XP",
                          style: TextStyle(
                              color: Colors.tealAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '"$title"' + ' 2/3',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Container(
                        width: 250,
                        child: Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                                height: 50,
                                child: TurtleImage(
                                    id: turtles[0][0], color: turtles[0][1])),
                            Opacity(
                              opacity: 0.4,
                              child: Container(
                                  height: 50,
                                  child: TurtleImage(
                                      id: turtles[1][0], color: turtles[1][1])),
                            ),
                            Container(
                                height: 50,
                                child: TurtleImage(
                                    id: turtles[2][0], color: turtles[2][1]))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
