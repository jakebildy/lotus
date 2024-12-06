import 'package:flutter/material.dart';
import 'package:meditate_app/components/turtle_image.dart';
import 'package:meditate_app/util/util.dart';

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
    int turtlesUnlocked =
        turtles.where((turtle) => hasTurtle(turtle[0], turtle[1])).length;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // Open the popup on tap
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: turtles
                              .map((turtle) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    height: 50,
                                    child: TurtleImage(
                                        id: turtle[0], color: turtle[1]),
                                  ))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Unlocked: $turtlesUnlocked/${turtles.length}",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text("You will earn $xp XP",
                          style: TextStyle(color: Colors.tealAccent)),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.tealAccent),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          // round border
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
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
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                      Text(
                        "+$xp XP",
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"$title"',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "$turtlesUnlocked/${turtles.length} TURTLES - TAP FOR DETAILS",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: turtles
                              .map((turtle) => Opacity(
                                    opacity: hasTurtle(turtle[0], turtle[1])
                                        ? 1
                                        : 0.4,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      height: 50,
                                      child: TurtleImage(
                                          id: turtle[0], color: turtle[1]),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
