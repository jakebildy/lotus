import 'dart:math';

import 'package:get/get.dart';
import 'package:meditate_app/controllers/save_controller.dart';

enum Rarity { COMMON, RARE, LEGENDARY }

enum Tier { ORANGE, YELLOW, BLUE, RAINBOW }

class Turtle {
  final String name;
  final Rarity rarity;
  final Tier tier;

  const Turtle({required this.name, required this.rarity, required this.tier})
      : super();
}

const List<Turtle> TURTLES = [
  Turtle(name: "Brownshell Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Greenshell Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Hexagon Turtle", rarity: Rarity.RARE, tier: Tier.YELLOW),
  Turtle(name: "Smoothback Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Obsidian Turtle", rarity: Rarity.RARE, tier: Tier.BLUE),
  Turtle(name: "Floragreen Turtle", rarity: Rarity.RARE, tier: Tier.RAINBOW),
  Turtle(name: "Litback Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Nether Turtle", rarity: Rarity.LEGENDARY, tier: Tier.YELLOW),
  Turtle(name: "Lavender Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Sun Turtle", rarity: Rarity.COMMON, tier: Tier.YELLOW),
  Turtle(name: "Red Giant Turtle", rarity: Rarity.COMMON, tier: Tier.YELLOW),
  Turtle(name: "White Dwarf Turtle", rarity: Rarity.RARE, tier: Tier.ORANGE),
  Turtle(name: "Poseidon Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Evergreen Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Watermelon Turtle", rarity: Rarity.RARE, tier: Tier.ORANGE),
  Turtle(name: "Honeyshell Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Citrus Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(name: "Magma Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
];

int getTurtleToHatch() {
  List<Turtle> possibleTurtles = TURTLES;
  int checkRarity = Random().nextInt(10);

  if (checkRarity < 7) {
    possibleTurtles = possibleTurtles
        .where((element) => element.rarity == Rarity.COMMON)
        .toList();
  } else if (checkRarity == 7 || checkRarity == 8) {
    possibleTurtles = possibleTurtles
        .where((element) => element.rarity == Rarity.RARE)
        .toList();
  } else {
    possibleTurtles = possibleTurtles
        .where((element) => element.rarity == Rarity.LEGENDARY)
        .toList();
  }

  //Filter by tier
  SaveController saveController = Get.find();
  if (saveController.streakTier() == Tier.ORANGE) {
    possibleTurtles = possibleTurtles
        .where((element) => element.tier == Tier.ORANGE)
        .toList();
  } else if (saveController.streakTier() == Tier.YELLOW) {
    possibleTurtles = possibleTurtles
        .where((element) =>
            element.tier == Tier.ORANGE || element.tier == Tier.YELLOW)
        .toList();
  } else if (saveController.streakTier() == Tier.BLUE) {
    possibleTurtles = possibleTurtles
        .where((element) =>
            element.tier == Tier.ORANGE ||
            element.tier == Tier.YELLOW ||
            element.tier == Tier.BLUE)
        .toList();
  }
  int result = 0;

  //Randomly choose a turtle from the available options
  Turtle selectedTurtle =
      possibleTurtles[Random().nextInt(possibleTurtles.length)];

  for (int i = 0; i < TURTLES.length; i++) {
    if (TURTLES[i] == selectedTurtle) {
      result = i;
    }
  }

  if (saveController.unlockedTurtles[result] > 0) {
    //Randomly choose a turtle from the available options
    Turtle selectedTurtle =
        possibleTurtles[Random().nextInt(possibleTurtles.length)];

    for (int i = 0; i < TURTLES.length; i++) {
      if (TURTLES[i] == selectedTurtle) {
        result = i;
      }
    }
  }

  return result;
}
