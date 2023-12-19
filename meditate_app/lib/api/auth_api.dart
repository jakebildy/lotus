import 'dart:convert';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as api;

class AuthApi {
  static var _singleton;
  String get url => api.url;
  AuthApi._internal();

  factory AuthApi() {
    if (_singleton == null) {
      _singleton = AuthApi._internal();
    }
    return _singleton;
  }

  //Endpoints
  Future<User> signup(
      String email, String password, String fullName, String username) async {
    final Map<String, String> map = {
      "email": email,
      "password": password,
      "fullName": fullName,
      "username": username,
      "lastSeenActivity": DateTime.now().toIso8601String(),
    };

    final String body = jsonEncode(map);
    final response = await http.post(api.https(url, "/api/auth/signup"),
        body: body, headers: api.headers);

    if (response.statusCode == 200) {
      api.updateCookie(response);
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  Future<User> login(String email, String password) async {
    final Map<String, String> map = {"email": email, "password": password};

    final String body = jsonEncode(map);
    final response = await http.post(api.https(url, "/api/auth/login"),
        body: body, headers: api.headers);

    if (response.statusCode == 200) {
      api.updateCookie(response);
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }

  // Future<User> verifyPhoneNumber(String code) async {
  //   final Map<String, String> map = {
  //     "code": code,
  //   };

  //   final String body = jsonEncode(map);
  //   final response = await http.post(Api.https(url, "/api/auth/verify/phone"),
  //       body: body, headers: Api.headers);

  //   if (response.statusCode == 200) {
  //     Api.updateCookie(response);
  //     return User.fromJson(json.decode(response.body));
  //   } else {
  //     throw (response.body);
  //   }
  // }

  // Future<String> resendPhoneNumberCode() async {
  //   final response = await http.post(Api.https(url, "/api/auth/resend/phone"),
  //       headers: Api.headers);
  //   if (response.statusCode == 200) {
  //     Api.updateCookie(response);
  //     return response.body;
  //   } else {
  //     throw (response.body);
  //   }
  // }

  // Future<bool> isPhoneNumberAvailable(String phoneNumber) async {
  //   final response = await http.post(
  //       Api.https(url, "/api/auth/isPhoneNumberAvailable/" + phoneNumber),
  //       headers: Api.headers);
  //   if (response.statusCode == 200) {
  //     Api.updateCookie(response);
  //     return json.decode(response.body)["available"] == true;
  //   } else {
  //     throw (response.body);
  //   }
  // }

  Future<String> logout() async {
    final response = await http.post(api.https(url, "/api/dev/logout/"),
        headers: api.headers);
    if (response.statusCode == 200) {
      api.updateCookie(response);
      return response.body;
    } else {
      throw (response.body);
    }
  }

  // Future<void> requestResetPasswordCode() async {
  //   final response = await http.post(Api.https(url, "/api/dev/logout/"),
  //       headers: Api.headers);
  //   if (response.statusCode == 200) {
  //     Api.updateCookie(response);
  //     return;
  //   } else {
  //     throw (response.body);
  //   }
  // }

  // Future<void> resetPassword(
  //     String phoneNumber, String code, String newPassword) async {
  //   final Map<String, String> map = {
  //     "phoneNumber": phoneNumber,
  //     "code": code,
  //     "newPassword": newPassword,
  //   };

  //   final String body = jsonEncode(map);
  //   final response = await http.post(
  //     Api.https(url, "/api/password/reset/"),
  //     headers: Api.headers,
  //     body: body,
  //   );

  //   if (response.statusCode == 200) {
  //     Api.updateCookie(response);
  //     return;
  //   } else {
  //     throw (response.body);
  //   }
  // }'

  // Future<void> requestResetPasswordToken(String phoneNumber) async {
  //   final response = await http.post(
  //     Api.https(
  //         url, "/api/password/request-reset-password-token/$phoneNumber/"),
  //     headers: Api.headers,
  //   );

  //   if (response.statusCode == 200) {
  //     Api.updateCookie(response);
  //     return;
  //   } else {
  //     throw (response.body);
  //   }
  // }
}
