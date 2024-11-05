// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditate_app/controllers/follow_controller.dart';
import 'package:meditate_app/controllers/user_controller.dart';
import 'package:meditate_app/util/logger.dart';

import 'ambiences.dart';

enum Rarity { COMMON, UNCOMMON, RARE, ULTRARARE, LEGENDARY }

enum Tier { ORANGE, LITBACK, YELLOW, BLUE, RAINBOW, AMBIENCE }

class Turtle {
  final String name;
  final Rarity rarity;
  final Tier tier;
  final int level;
  final Ambience? foundIn;

  const Turtle(
      {required this.name,
      required this.rarity,
      required this.tier,
      this.level = 1,
      this.foundIn})
      : super();
}

const List<Color> TURTLE_COLORS = [
  Colors.brown,
  Colors.red,
  Colors.deepOrange,
  Colors.orange,
  Colors.yellow,
  Colors.lime,
  Colors.green,
  Colors.teal,
  Colors.cyan,
  Colors.blue,
  Colors.indigo,
  Colors.deepPurple,
  Colors.purple,
  Colors.pink,
  Color.fromARGB(255, 237, 121, 139),
  Colors.black,
  Colors.grey,
  Colors.white,
  Colors.transparent, //Rainbow
];
const List<String> TURTLE_COLORS_NAME = [
  "Brown",
  "Red",
  "Sunset",
  "Orange",
  "Yellow",
  "Lime",
  "Green",
  "Teal",
  "Cyan",
  "Blue",
  "Indigo",
  "Royal",
  "Purple",
  "Pink",
  "Coral",
  "Black",
  "Gray",
  "White",
  "Rainbow"
];

//ignore: non_constant_identifier_names
List<Turtle> TURTLES = [
  const Turtle(name: "Swamp Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  const Turtle(
      name: "Rockshell Turtle",
      rarity: Rarity.COMMON,
      tier: Tier.YELLOW,
      level: 3),
  const Turtle(name: "Hexagon Turtle", rarity: Rarity.RARE, tier: Tier.ORANGE),
  const Turtle(
      name: "Smoothback Turtle",
      rarity: Rarity.COMMON,
      tier: Tier.ORANGE,
      level: 2),
  const Turtle(
      name: "Obsidian Turtle",
      rarity: Rarity.RARE,
      tier: Tier.ORANGE,
      level: 4),
  const Turtle(
      name: "Flora Turtle",
      rarity: Rarity.ULTRARARE,
      tier: Tier.ORANGE,
      level: 10),
  const Turtle(
      name: "Litback Turtle", rarity: Rarity.COMMON, tier: Tier.LITBACK),
  const Turtle(
      name: "Nether Turtle", rarity: Rarity.LEGENDARY, tier: Tier.ORANGE),
  const Turtle(
      name: "Swirl Turtle",
      rarity: Rarity.UNCOMMON,
      tier: Tier.ORANGE,
      level: 2),
  const Turtle(
      name: "Sun Turtle", rarity: Rarity.RARE, tier: Tier.ORANGE, level: 5),
  const Turtle(
      name: "Crystal Turtle",
      rarity: Rarity.LEGENDARY,
      tier: Tier.ORANGE,
      level: 10),
  const Turtle(
      name: "Balance Turtle",
      rarity: Rarity.RARE,
      tier: Tier.ORANGE,
      level: 20),
  const Turtle(
      name: "Poseidon Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  const Turtle(
      name: "Evergreen Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  const Turtle(
      name: "Watermelon Turtle", rarity: Rarity.RARE, tier: Tier.ORANGE),
  const Turtle(
      name: "Honeyshell Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  const Turtle(name: "Citrus Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  const Turtle(
      name: "Magma Turtle", rarity: Rarity.RARE, tier: Tier.ORANGE, level: 5),
  const Turtle(
      name: "Silphium Turtle", rarity: Rarity.COMMON, tier: Tier.ORANGE),
  Turtle(
      name: "Luna Turtle",
      rarity: Rarity.RARE,
      tier: Tier.AMBIENCE,
      foundIn: AMBIENCES[2]),
  const Turtle(
      name: "World Turtle", rarity: Rarity.LEGENDARY, tier: Tier.ORANGE),
  Turtle(
      name: "Dino Turtle",
      rarity: Rarity.COMMON,
      tier: Tier.AMBIENCE,
      foundIn: AMBIENCES[14]),
  Turtle(
      name: "Lightning Turtle",
      rarity: Rarity.COMMON,
      tier: Tier.AMBIENCE,
      foundIn: AMBIENCES[11]),
];

int getTurtleToHatch(String ambience) {
  List<Turtle> possibleTurtles = TURTLES;

  //If the user doesn't have at least one friend OR follow controller doesnt exist, filter the Litback turtle

  bool isControllerRegistered = Get.isRegistered<FollowController>();
  if (!isControllerRegistered) {
    possibleTurtles = possibleTurtles
        .where((element) => element.name != "Litback Turtle")
        .toList();
  } else {
    FollowController followController = Get.find();

    if (followController.following.isEmpty) {
      possibleTurtles = possibleTurtles
          .where((element) => element.name != "Litback Turtle")
          .toList();
    }
  }

  // Only show ambience turtles if the user meditated with that ambience
  possibleTurtles = possibleTurtles
      .where((element) =>
          element.foundIn == null || element.foundIn!.name == ambience)
      .toList();

  int checkRarity = Random().nextInt(10);

  //TODO: improve rarity equation
  if (checkRarity < 4) {
    possibleTurtles = possibleTurtles
        .where((element) => element.rarity == Rarity.COMMON)
        .toList();
  } else if (checkRarity < 6) {
    possibleTurtles = possibleTurtles
        .where((element) =>
            element.rarity == Rarity.COMMON ||
            element.rarity == Rarity.UNCOMMON)
        .toList();
  } else if (checkRarity == 6 || checkRarity == 7 || checkRarity == 8) {
    possibleTurtles = possibleTurtles
        .where((element) => element.rarity != Rarity.LEGENDARY)
        .toList();
  }

  //Filter by tier
  UserController userController = Get.find();
  if (userController.streakTier() == Tier.ORANGE) {
    possibleTurtles = possibleTurtles
        .where((element) =>
            element.tier == Tier.ORANGE ||
            element.tier == Tier.LITBACK ||
            element.tier == Tier.AMBIENCE)
        .toList();
  } else if (userController.streakTier() == Tier.YELLOW) {
    possibleTurtles = possibleTurtles
        .where((element) =>
            element.tier == Tier.ORANGE ||
            element.tier == Tier.YELLOW ||
            element.tier == Tier.LITBACK ||
            element.tier == Tier.AMBIENCE)
        .toList();
  } else if (userController.streakTier() == Tier.BLUE) {
    possibleTurtles = possibleTurtles
        .where((element) =>
            element.tier == Tier.ORANGE ||
            element.tier == Tier.YELLOW ||
            element.tier == Tier.BLUE ||
            element.tier == Tier.LITBACK ||
            element.tier == Tier.AMBIENCE)
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

  return result;
}

//This is for sorting the lockedTurtles
List<int> listOfIndicesByTier(List<dynamic> unlockedTurtles) {
  // returns a list of indices corresponding to the turtles sorted by tier
  List<int> orangeTurtles = [];
  List<int> litbackTurtles = [];
  List<int> yellowTurtles = [];
  List<int> blueTurtles = [];
  List<int> rainbowTurtles = [];
  List<int> ambienceTurtles = [];

  for (int i = 0; i < TURTLES.length; i++) {
    if (unlockedTurtles[i] <= 0) {
      if (TURTLES[i].tier == Tier.ORANGE) {
        orangeTurtles.add(i);
      } else if (TURTLES[i].tier == Tier.LITBACK) {
        litbackTurtles.add(i);
      } else if (TURTLES[i].tier == Tier.YELLOW) {
        yellowTurtles.add(i);
      } else if (TURTLES[i].tier == Tier.BLUE) {
        blueTurtles.add(i);
      } else if (TURTLES[i].tier == Tier.RAINBOW) {
        rainbowTurtles.add(i);
      } else {
        ambienceTurtles.add(i);
      }
    }
  }

  // combine all lists
  orangeTurtles.addAll(litbackTurtles);
  orangeTurtles.addAll(yellowTurtles);
  orangeTurtles.addAll(blueTurtles);
  orangeTurtles.addAll(rainbowTurtles);
  orangeTurtles.addAll(ambienceTurtles);

  logError(orangeTurtles.toString());
  return orangeTurtles;
}

//This is for sorting
List<int> listOfIndicesByRarity(List<dynamic> unlockedTurtles) {
  // returns a list of indices corresponding to the turtles sorted by tier
  List<int> commonTurtles = [];
  List<int> uncommonTurtles = [];
  List<int> rareTurtles = [];
  List<int> legendaryTurtles = [];

  for (int i = 0; i < TURTLES.length; i++) {
    if (unlockedTurtles[i] <= 0) {
      if (TURTLES[i].rarity == Rarity.COMMON) {
        commonTurtles.add(i);
      } else if (TURTLES[i].rarity == Rarity.UNCOMMON) {
        uncommonTurtles.add(i);
      } else if (TURTLES[i].rarity == Rarity.RARE) {
        rareTurtles.add(i);
      } else {
        legendaryTurtles.add(i);
      }
    }
  }

  // combine all lists
  commonTurtles.addAll(uncommonTurtles);
  commonTurtles.addAll(rareTurtles);
  commonTurtles.addAll(legendaryTurtles);

  return commonTurtles;
}
