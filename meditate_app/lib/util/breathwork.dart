class Breathwork {
  final String name;
  final String description;
  final String whenToUse;

  final String emoji;
  final List<int> inOutTimes;
  final List<String> instructions;

  const Breathwork({
    required this.name,
    required this.description,
    required this.whenToUse,
    required this.emoji,
    required this.inOutTimes,
    required this.instructions,
  }) : super();
}

// ignore: constant_identifier_names
const List<Breathwork> BREATHWORKS = [
  Breathwork(
      name: "4-7-8 Breathing",
      description: "Relax and fall asleep",
      whenToUse: "Before bed",
      emoji: '💤',
      inOutTimes: [
        4,
        7,
        8
      ],
      instructions: [
        "Breathe in",
        "Hold",
        "Breathe out",
      ]),
  Breathwork(
      name: "Box Breathing",
      description: "Calm and focus when stressed or anxious",
      whenToUse: "Before a big event",
      emoji: '■',
      inOutTimes: [4, 4, 4, 4],
      instructions: ["Breathe in", "Hold", "Breathe out", "Hold"]),
  Breathwork(
    name: "5-5 Breathing",
    description: "Regain balance and center yourself",
    whenToUse: "Stop Overthinking",
    emoji: '🧘',
    inOutTimes: [5, 5],
    instructions: ["Breathe in", "Breathe out"],
  ),
];
