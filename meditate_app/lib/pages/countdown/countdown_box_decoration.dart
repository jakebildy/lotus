import 'package:flutter/material.dart';
import 'package:meditate_app/util/ambiences.dart';

BoxDecoration getBoxDecorationForAmbience(String ambience) {
  final ambienceSetting = AMBIENCES
      .firstWhere(
        (element) => element.name == ambience,
        orElse: () => throw Exception('Ambience not found'),
      )
      .setting;

  switch (ambienceSetting) {
    case "Rain":
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 205, 205, 205),
            Color(0xff87CEEB),
            Color.fromARGB(255, 25, 178, 238),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromARGB(255, 255, 255, 255),
            Color(0xff87CEEB),
            Color.fromARGB(255, 25, 178, 238),
          ],
        ),
      );
    case "Night":
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.black,
            Color.fromARGB(255, 183, 163, 211),
          ],
        ),
      );
    default:
      return const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff87CEEB),
            Color(0xff87CEEB),
            Color.fromARGB(255, 25, 178, 238),
            Color.fromARGB(255, 183, 163, 211),
            Color.fromARGB(255, 247, 190, 221),
            Color.fromARGB(255, 247, 244, 186),
            Color(0xff87CEEB),
            Color.fromARGB(255, 25, 178, 238),
          ],
        ),
      );
  }
}
