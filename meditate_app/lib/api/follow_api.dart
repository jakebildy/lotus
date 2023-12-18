import 'dart:convert';
import 'package:meditate_app/models/follow.dart';
import 'package:meditate_app/util/logger.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as Api;

class FollowApi {
  static var _singleton;
  String get url => Api.url;
  FollowApi._internal();

  factory FollowApi() {
    if (_singleton == null) {
      _singleton = FollowApi._internal();
    }
    return _singleton;
  }

  //Endpoints

  Future<List<Follow>> getFollowing() async {
    final response = await http.get(Api.https(url, "/api/follow/following"),
        headers: Api.headers);
    if (response.statusCode == 200) {
      return Follow.listFromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<List<Follow>> getFollowers() async {
    final response = await http.get(Api.https(url, "/api/follow/followers"),
        headers: Api.headers);
    if (response.statusCode == 200) {
      return Follow.listFromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<List<Follow>> getStylistFollowing(User stylist) async {
    final response = await http.get(
        Api.https(url, "/api/follow/stylist/following/${stylist.id}"),
        headers: Api.headers);
    if (response.statusCode == 200) {
      return Follow.listFromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<List<User>> getStylistNotFollowing(User stylist) async {
    final response = await http.get(
        Api.https(url, "/api/follow/stylist/not-following/${stylist.id}"),
        headers: Api.headers);
    if (response.statusCode == 200) {
      return User.listFromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<List<Follow>> getStylistFollowers(User stylist) async {
    final response = await http.get(
        Api.https(url, "/api/follow/stylist/followers/${stylist.id}"),
        headers: Api.headers);
    if (response.statusCode == 200) {
      return Follow.listFromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<void> followUser(User user) async {
    final response = await http.post(
        Api.https(url, "/api/follow/stylist/" + user.id!),
        headers: Api.headers);
    if (response.statusCode == 200) {
      logSuccess(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<void> sendEmoji(String userId, String emoji) async {
    final response = await http.post(
        Api.https(url, "/api/emoji/" + userId + "/" + emoji),
        headers: Api.headers);
    if (response.statusCode == 200) {
      logSuccess(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<void> unfollowUser(User user) async {
    final response = await http.delete(
        Api.https(url, "/api/unfollow/user/" + user.id!),
        headers: Api.headers);
    if (response.statusCode == 200) {
      logSuccess(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }
}
