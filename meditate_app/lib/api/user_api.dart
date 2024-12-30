import 'dart:convert';
import 'package:get/get.dart';
import 'package:meditate_app/services/posthog_service.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as api;

class UserApi {
  static UserApi? _singleton;
  String get url => api.url;
  UserApi._internal();

  factory UserApi() {
    _singleton ??= UserApi._internal();
    return _singleton!;
  }

  //Endpoints
  Future<User> changeName(String name) async {
    final Map<String, String> map = {
      "name": name,
    };

    final String body = jsonEncode(map);
    final response = await http.post(api.https(url, "/api/user/changeName"),
        body: body, headers: api.headers);

    if (response.statusCode == 200) {
      api.updateCookie(response);
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<User> me() async {
    final response =
        await http.get(api.https(url, "/api/user/me"), headers: api.headers);
    if (response.statusCode == 200) {
      api.updateCookie(response);
      PostHogService posthog = Get.find();
      posthog.identifyUser(json.decode(response.body)["username"]);
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
    final response = await http.post(api.https(url, "/api/user/update"),
        body: body, headers: api.headers);

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
    final response = await http.post(api.https(url, "/api/user/update"),
        body: body, headers: api.headers);
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
    final response = await http.post(api.https(url, "/api/user/update"),
        body: body, headers: api.headers);

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
        api.https(url, "/api/user/getUsersFromUserIds"),
        body: body,
        headers: api.headers);

    if (response.statusCode == 200) {
      api.updateCookie(response);
      return json.decode(response.body);
    } else {
      throw (response.body);
    }
  }

  Future<void> updateDeviceToken(String token) async {
    final response = await http.post(
        api.https(url, "/api/user/update-device-token/" + token),
        headers: api.headers);
    if (response.statusCode == 200) {
      api.updateCookie(response);
      return;
      //response.body;
    } else {
      throw (response.body);
    }
  }

  Future<void> updateTimezoneOffset(int timezoneOffset) async {
    final response = await http.post(
        api.https(url,
            "/api/user/update-timezone-offset/" + timezoneOffset.toString()),
        headers: api.headers);
    if (response.statusCode == 200) {
      api.updateCookie(response);
      return;
      //response.body;
    } else {
      throw (response.body);
    }
  }

  Future<User> resetPasswordEmail(String email) async {
    final Map<String, String> map = {
      "email": email,
    };

    final String body = jsonEncode(map);
    final response = await http.post(api.https(url, "/api/reset-password"),
        body: body, headers: api.headers);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<User?> getUserFromUsername(String username) async {
    final response = await http.get(
        api.https(url, "/api/user/username/$username"),
        headers: api.headers);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<void> userSubscribed(String email) async {
    final Map<String, String> map = {
      "email": email,
    };

    final String body = jsonEncode(map);

    final response = await http.post(api.https(url, "/api/user/subscribed/"),
        body: body, headers: api.headers);
    if (response.statusCode == 200) {
      return;
      //response.body;
    } else {
      throw (response.body);
    }
  }
}
