import 'package:flutter/material.dart';
import 'package:meditate_app/components/piechart_painter.dart';
import 'package:meditate_app/components/turtle_image.dart';
import 'package:meditate_app/util/turtles.dart';
import 'package:meditate_app/util/util.dart';

class TrophyWidget extends StatelessWidget {
  final String title;

  final int xp;
  final List<List<int>> turtles;
  const TrophyWidget(
      {super.key,
      required this.title,
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
          if (turtlesUnlocked == turtles.length) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    title + (turtlesUnlocked == turtles.length ? " ✅" : ""),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "You unlocked this collection! The XP has been added to your account.",
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.tealAccent),
                      ),
                    ),
                  ],
                );
              },
            );
            return;
          }

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
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // draft the description from the list of turtles, it should be Collect a 'Royal Sunset Turtle (example)', 'turtle2', 'turtle3' and 'turtle4'
                        "Collect a " +
                            turtles
                                .toList()
                                .map((
                                  turtle,
                                ) =>
                                    (turtle == turtles.last ? "& " : "") +
                                    TURTLE_COLORS_NAME[turtle[1]] +
                                    " " +
                                    TURTLES[turtle[0]].name)
                                .join(", "),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Unlocked: $turtlesUnlocked/${turtles.length}",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text("You will earn $xp XP",
                          style: const TextStyle(color: Colors.tealAccent)),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
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
            color: turtlesUnlocked == turtles.length
                ? const Color.fromARGB(255, 46, 48, 59)
                : Colors.black12,
            border: Border.all(
                color: turtlesUnlocked == turtles.length
                    ? const Color.fromARGB(255, 81, 80, 107)
                    : Colors.white24,
                width: 2),
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
                          turtlesUnlocked == turtles.length
                              ? Icons.emoji_events
                              : Icons.emoji_events_outlined,
                          color: turtlesUnlocked == turtles.length
                              ? Colors.lightBlue
                              : Colors.white12,
                          size: 40,
                        ),
                      ),
                      Text(
                        "+$xp XP",
                        style: TextStyle(
                          color: turtlesUnlocked == turtles.length
                              ? Colors.white12
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$title',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: turtlesUnlocked == turtles.length
                                ? Colors.lightBlue
                                : Colors.white,
                            fontWeight: turtlesUnlocked == turtles.length
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          CustomPaint(
                            size: const Size(3, 3), // Size of the pie chart
                            painter: PieChartPainter(
                              percentage:
                                  turtlesUnlocked / turtles.length * 100,
                              fillColor: Colors.lightBlue,
                              backgroundColor: Colors.white24,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            turtlesUnlocked == turtles.length
                                ? "$turtlesUnlocked/${turtles.length} COLLECTED"
                                : "$turtlesUnlocked/${turtles.length} TURTLES - TAP FOR DETAILS",
                            style: TextStyle(
                                color: turtlesUnlocked == turtles.length
                                    ? Colors.white
                                    : Colors.white70,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
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
