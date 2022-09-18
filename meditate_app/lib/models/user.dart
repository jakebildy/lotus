const String SHREK =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

class User {
  final String? id;
  final String avatar;
  final String fullName;
  final String email;
  final String username;

  final String streetAddress;
  final String apt;
  final String city;
  final String state;
  final String zipcode;
  final DateTime lastSeenActivity;
  final DateTime createdAt;
  final String clothingGender;

  final bool showGenderPopup;

  static User deletedUser = User(
      id: "-1",
      email: "...",
      fullName: "Deleted User",
      username: "null",
      lastSeenActivity: DateTime.now(),
      createdAt: DateTime.now());

  const User(
      {this.id,
      required this.email,
      required this.fullName,
      required this.username,
      required this.lastSeenActivity,
      required this.createdAt,
      this.avatar = SHREK,
      this.streetAddress = "",
      this.apt = "",
      this.city = "",
      this.state = "",
      this.zipcode = "",
      this.clothingGender = "",
      this.showGenderPopup = false});

  static User fromJson(Map<String, dynamic> map) {
    return User(
        id: map["_id"],
        email: map["email"] ?? "",
        fullName: map['fullName'] ?? "",
        username:
            (map["username"] ?? "user22").replaceAll(" ", "").toLowerCase(),
        lastSeenActivity: DateTime.parse(
            map["lastSeenActivity"] ?? "2011-10-05T14:48:00.000Z"),
        createdAt:
            DateTime.parse(map["createdAt"] ?? "2011-10-05T14:48:00.000Z"),
        avatar: map["avatar"] ?? SHREK,
        streetAddress: map["streetAddress"] ?? "",
        apt: map["apt"] ?? "",
        city: map["city"] ?? "",
        state: map["state"] ?? "",
        zipcode: map["zipcode"] ?? "",
        clothingGender: map["clothingGender"] ?? "All",
        showGenderPopup: map["clothingGender"] != null ? false : true);
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
