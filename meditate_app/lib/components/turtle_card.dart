import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TurtleCard extends StatelessWidget {

  final bool unlocked;
  const TurtleCard({Key? key, required this.unlocked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: unlocked ? Image.asset("assets/turtles/0.png") :
      Image.asset("assets/turtles/locked.png")
  );
  }
}