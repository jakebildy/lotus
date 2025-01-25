import 'package:meditate_app/util/turtles.dart';

class Collection {
  final String title;
  final int xp;
  final List<List<int>> turtles;

  const Collection({
    required this.title,
    required this.xp,
    required this.turtles,
  }) : super();
}

// ignore: non_constant_identifier_names

List<Collection> COLLECTIONS = [
  const Collection(title: "My First Turtle", xp: 5, turtles: [
    [0, 0],
  ]),

  const Collection(title: "Honey", xp: 20, turtles: [
    [15, 4],
    [15, 15],
  ]),

  const Collection(title: "Origins", xp: 20, turtles: [
    [0, 0],
    [1, 0],
  ]),

  const Collection(title: "Coffee", xp: 20, turtles: [
    [3, 0],
    [8, 17],
  ]),

  const Collection(title: "Vaporwave", xp: 20, turtles: [
    [24, 9],
    [25, 17],
  ]),

  const Collection(title: "Fire Portal", xp: 40, turtles: [
    [4, 12],
    [6, 2],
    [7, 1],
    [17, 4]
  ]),

  const Collection(title: "Celestial Harmony", xp: 100, turtles: [
    [9, 4],
    [19, 16],
    [20, 9],
    [20, 6]
  ]),

  const Collection(title: "Fruit Salad", xp: 50, turtles: [
    [14, 13],
    [16, 6],
    [15, 5],
    [16, 3],
  ]),

  const Collection(title: "Olympus", xp: 80, turtles: [
    [23, 17],
    [12, 9],
    [22, 4]
  ]),

  const Collection(title: "Floating Cities on Venus", xp: 100, turtles: [
    [23, 9],
    [9, 17],
    [8, 12],
    [4, 10]
  ]),

  const Collection(title: "Yearning for Mines", xp: 200, turtles: [
    [1, 15],
    [1, 16],
    [10, 18],
    [4, 15]
  ]),

  // For all turtles, create a collection for collecting all colors of it
  ...List.generate(
      TURTLES.length,
      (i) => Collection(
          title: TURTLES[i].name.replaceAll(" Turtle", "") + " Collection",
          xp: 500 + 50 * TURTLES[i].level + 50 * TURTLES[i].rarity.index,
          turtles: List.generate(TURTLE_COLORS.length, (j) => [i, j]))),

  Collection(
      title: "Rainbow Collection",
      xp: 2000,
      turtles: List.generate(TURTLES.length, (i) => [i, 18]))
];
