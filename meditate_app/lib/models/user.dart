const String SHREK =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

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
  final DateTime lastMeditated;
  final List<dynamic> meditationTimes;
  final DateTime meditationTimesAsOf;

  static User deletedUser = User(
      id: "-1",
      email: "...",
      fullName: "Deleted User",
      username: "null",
      lastMeditated: DateTime.now(),
      meditationTimesAsOf: DateTime.now(),
      createdAt: DateTime.now());

  const User({
    this.id,
    required this.email,
    required this.fullName,
    required this.username,
    required this.createdAt,
    required this.lastMeditated,
    this.meditationTimes = const [],
    required this.meditationTimesAsOf,
    this.avatar = SHREK,
    this.streak = 0,
    this.totalMinutes = 0,
    this.gems = 0,
    this.eggs = 0,
    this.totalEggs = 0,
    this.hatchProgressEggOne = 0,
  });

  static User fromJson(Map<String, dynamic> map) {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    int numDays =
        DateTime.parse(map["lastMeditated"] ?? "2011-10-05T14:48:00.000Z")
            .difference(date)
            .inDays
            .abs();

    return User(
      id: map["_id"],
      email: map["email"] ?? "",
      fullName: map['fullName'] ?? "",
      username: (map["username"] ?? "user22").replaceAll(" ", "").toLowerCase(),
      createdAt: DateTime.parse(map["createdAt"] ?? "2011-10-05T14:48:00.000Z"),
      avatar: map["avatar"] ?? SHREK,
      streak: numDays > 1
          ? 0
          : map["streak"] ??
              0, // TODO - verify against number of streak freezes + time last logged in
      totalMinutes: map["totalMinutes"] ?? 0,
      eggs: map["eggs"] ?? 0,
      totalEggs: map["totalEggs"] ?? 0,
      hatchProgressEggOne: map["hatchProgressEggOne"] ?? 0,
      lastMeditated:
          DateTime.parse(map["lastMeditated"] ?? "2011-10-05T14:48:00.000Z"),
      meditationTimes: map["meditationTimes"],
      meditationTimesAsOf: DateTime.parse(
          map["meditationTimesAsOf"] ?? "2011-10-05T14:48:00.000Z"),
    );
  }

  //Iterates through a list of maps and returns a list of User objects
  static List<User> listFromJson(List<dynamic> listMaps) {
    List<User> users = [];

    for (Map<String, dynamic> item in listMaps) {
      users.add(User.fromJson(item));
    }

    return users;
  }
}
