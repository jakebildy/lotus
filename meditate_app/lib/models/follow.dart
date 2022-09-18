import 'package:meditate_app/models/user.dart';

class Follow {
  final String? id;
  final String type;
  final User? stylist;
  final User user;
  final DateTime? createdAt;

  const Follow({
    this.id,
    required this.type,
    required this.user,
    this.stylist,
    this.createdAt,
  });

  static Follow fromJson(Map<String, dynamic> map) {
    return Follow(
        id: map["_id"],
        type: map["type"],
        user: User.fromJson(map["user"]),
        stylist:
            map["type"] == "Stylist" ? User.fromJson(map["stylist"]) : null,
        createdAt: DateTime.parse(map["createdAt"]));
  }

  //Iterates through a list of maps and returns a list of Follow objects
  static List<Follow> listFromJson(List<dynamic> listMaps) {
    List<Follow> follows = [];

    for (Map<String, dynamic> item in listMaps) {
      follows.add(Follow.fromJson(item));
    }

    return follows;
  }
}
