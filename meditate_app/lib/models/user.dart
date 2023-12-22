import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meditate_app/util/turtles.dart';

const String defaultProfilePicture =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

enum UserProperty {
  streak,
  totalMinutes,
  gems,
  eggs,
  totalEggs,
  hatchProgressEggOne,
  streakFreezes,
  lastMeditated,
  meditationTimes,
  meditationTimesAsOf,
  unlockedTurtles,
  unlockedTurtleColors,
  meditationHistory,
  eggTypes,
  emojisSentAt,
  sentEmojis,
}

class User {
  final String? id;
  final String avatar;
  final String fullName;
  final String email;
  final String username;
  final DateTime createdAt;

  final int streak;
  final int totalMinutes;
  final int gems;
  final int eggs;
  final int totalEggs;
  final int hatchProgressEggOne;
  final int streakFreezes;
  final DateTime lastMeditated;
  final List<dynamic> meditationTimes;
  final DateTime meditationTimesAsOf;

  final List<dynamic> unlockedTurtles;
  final List<List<int>> unlockedTurtleColors;
  RxMap<DateTime, int> meditationHistory;
  final List<String> eggTypes;

  /// Maps the User ID the emoji was sent to, to the DateTime of the last emoji sent to them
  RxMap<String, DateTime> emojisSentAt;

  /// Maps the User ID the emoji was sent to, to the emoji sent
  RxMap<String, String> sentEmojis;

  static User deletedUser = User(
    id: "-1",
    email: "...",
    fullName: "Deleted User",
    username: "null",
    lastMeditated: DateTime.now(),
    meditationTimesAsOf: DateTime.now(),
    createdAt: DateTime.now(),
  );

  User({
    this.id,
    required this.email,
    required this.fullName,
    required this.username,
    required this.createdAt,
    required this.lastMeditated,
    RxMap<DateTime, int>? meditationHistory,
    RxMap<String, DateTime>? emojisSentAt,
    RxMap<String, String>? sentEmojis,
    this.meditationTimes = const [],
    required this.meditationTimesAsOf,
    this.avatar = defaultProfilePicture,
    this.streak = 0,
    this.totalMinutes = 0,
    this.gems = 0,
    this.eggs = 0,
    this.totalEggs = 0,
    this.hatchProgressEggOne = 0,
    this.streakFreezes = 0,
    this.unlockedTurtles = const [],
    this.unlockedTurtleColors = const [],
    this.eggTypes = const [],
  })  : meditationHistory = meditationHistory ?? <DateTime, int>{}.obs,
        emojisSentAt = emojisSentAt ?? <String, DateTime>{}.obs,
        sentEmojis = sentEmojis ?? <String, String>{}.obs;

  // Method to parse the meditation history according to the key format used in loadData
  static Map<DateTime, int> _parseMeditationHistory(
      Map<String, dynamic>? jsonMap) {
    Map<DateTime, int> meditationHistory = {};
    jsonMap?.forEach((key, value) {
      DateFormat format = DateFormat('dd-MM-yyyy');
      DateTime date = format.parse(key.replaceAll("meditation-", ""), true);
      int duration = value is int ? value : int.tryParse(value.toString()) ?? 0;
      meditationHistory[date] = duration;
    });
    return meditationHistory;
  }

  static Map<String, String> _parseSentEmojis(Map<String, dynamic>? jsonMap) {
    Map<String, String> sentEmojis = {};
    jsonMap?.forEach((key, value) {
      sentEmojis[key] = value.toString();
    });
    return sentEmojis;
  }

  // Method to create a User object from a JSON map
  static User fromJson(Map<String, dynamic> map) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    int numDays =
        DateTime.parse(map["lastMeditated"] ?? "2011-10-05T14:48:00.000Z")
            .difference(date)
            .inDays
            .abs();

    var unlockedTurtles = map["unlockedTurtles"] as List<dynamic>? ?? [];
    var unlockedTurtleColors =
        (map["unlockedTurtleColors"] as List<dynamic>? ?? []).map((item) {
      if (item is List) {
        return item.map((e) => e as int).toList();
      } else {
        return [-1];
      }
    }).toList();

    for (int i = 0; i < TURTLES.length; i++) {
      if (unlockedTurtles.length <= i || unlockedTurtles[i] == null) {
        unlockedTurtles.add(0);
      }

      if (unlockedTurtleColors.length <= i) {
        unlockedTurtleColors.add([]);
      }
    }

    return User(
      id: map["_id"],
      email: map["email"] ?? "",
      fullName: map['fullName'] ?? "",
      username: (map["username"] ?? "user22").replaceAll(" ", "").toLowerCase(),
      createdAt: DateTime.parse(map["createdAt"] ?? "2011-10-05T14:48:00.000Z"),
      avatar: map["avatar"] ?? defaultProfilePicture,
      streak: numDays > 1
          ? 0
          : map["streak"] ??
              0, // TODO - verify against number of streak freezes + time last logged in
      totalMinutes: map["totalMinutes"] ?? 0,
      gems: map["gems"] ?? 0,
      eggs: map["eggs"] ?? 0,
      totalEggs: map["totalEggs"] ?? 0,
      hatchProgressEggOne: map["hatchProgressEggOne"] ?? 0,
      streakFreezes: map["streakFreezes"] ?? 0,
      lastMeditated:
          DateTime.parse(map["lastMeditated"] ?? "2011-10-05T14:48:00.000Z"),
      meditationTimes: map["meditationTimes"] ?? [],
      meditationTimesAsOf: DateTime.parse(
          map["meditationTimesAsOf"] ?? "2011-10-05T14:48:00.000Z"),
      unlockedTurtles: unlockedTurtles,
      unlockedTurtleColors: unlockedTurtleColors,
      eggTypes: (map["eggTypes"] as List<dynamic>? ?? []).cast<String>(),
      meditationHistory: _parseMeditationHistory(
              map["meditationHistory"] as Map<String, dynamic>?)
          .obs,
      emojisSentAt: (map["emojisSentAt"] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, DateTime.parse(value)))
              .obs ??
          <String, DateTime>{}.obs,
      sentEmojis:
          _parseSentEmojis(map["sentEmojis"] as Map<String, dynamic>?).obs,
    );
  }

  // Method to parse a list of User objects from a list of JSON maps
  static List<User> listFromJson(List<dynamic> listMaps) {
    return listMaps
        .map((map) => User.fromJson(map as Map<String, dynamic>))
        .toList();
  }
}
