import 'dart:convert';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as Api;

class UserApi {
  static var _singleton;
  String get url => Api.url;
  UserApi._internal();

  factory UserApi() {
    _singleton ??= UserApi._internal();
    return _singleton;
  }

  //Endpoints
  Future<User> changeName(String name) async {
    final Map<String, String> map = {
      "name": name,
    };

    final String body = jsonEncode(map);
    final response = await http.post(Api.https(url, "/api/user/changeName"),
        body: body, headers: Api.headers);

    if (response.statusCode == 200) {
      Api.updateCookie(response);
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<User> me() async {
    final response =
        await http.get(Api.https(url, "/api/user/me"), headers: Api.headers);
    if (response.statusCode == 200) {
      Api.updateCookie(response);
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<User> updateUser(String fullName) async {
    final Map<String, String> map = {
      "fullName": fullName,
    };

    final String body = jsonEncode(map);
    final response = await http.post(Api.https(url, "/api/user/update"),
        body: body, headers: Api.headers);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<User> updateUserAttribute(
      String attributeName, dynamic attribute) async {
    final Map<String, dynamic> map = {
      attributeName: attribute,
    };

    final String body = jsonEncode(map);
    final response = await http.post(Api.https(url, "/api/user/update"),
        body: body, headers: Api.headers);
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<User> updateLastSeenActivity() async {
    final Map<String, String> map = {
      "lastSeenActivity": DateTime.now().toUtc().toIso8601String(),
    };

    final String body = jsonEncode(map);
    final response = await http.post(Api.https(url, "/api/user/update"),
        body: body, headers: Api.headers);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<List<dynamic>> getUsersFromUserIds(List<String> userIDs) async {
    final Map<String, List<String>> map = {
      "userIds": userIDs,
    };

    final String body = jsonEncode(map);

    final response = await http.post(
        Api.https(url, "/api/user/getUsersFromUserIds"),
        body: body,
        headers: Api.headers);

    if (response.statusCode == 200) {
      Api.updateCookie(response);
      return json.decode(response.body);
    } else {
      throw (response.body);
    }
  }

  Future<void> updateDeviceToken(String token) async {
    final response = await http.post(
        Api.https(url, "/api/user/update-device-token/" + token),
        headers: Api.headers);
    if (response.statusCode == 200) {
      Api.updateCookie(response);
      return;
      //response.body;
    } else {
      throw (response.body);
    }
  }

  Future<User?> getUserFromUsername(String username) async {
    final response = await http.get(
        Api.https(url, "/api/user/username/${username}"),
        headers: Api.headers);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }
}
