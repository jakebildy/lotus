// ignore_for_file: constant_identifier_names

import 'package:http/http.dart' as http;
import 'package:meditate_app/api/analytics_api.dart';
import 'package:meditate_app/api/auth_api.dart';
import 'package:meditate_app/api/follow_api.dart';
import 'package:meditate_app/api/search_api.dart';
import 'package:meditate_app/api/user_api.dart';

const String LOCAL_URL = "localhost:8000";
const String REMOTE_URL = "shellevate.uc.r.appspot.com";

const bool TESTING = false;

Map<String, String> _cookies = {};
Map<String, String> get cookiesMap => _cookies;

AuthApi auth = AuthApi();
UserApi user = UserApi();
AnalyticsApi analytics = AnalyticsApi();
FollowApi follow = FollowApi();
SearchApi search = SearchApi();

String get url => TESTING ? LOCAL_URL : REMOTE_URL;
// String get socketUrl => TESTING ? LOCAL_URL : REMOTE_URL_SOCKET;

String get cookies => _generateCookieHeader();
Map<String, String> get headers => {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "cookie": cookies
    };

String _generateCookieHeader() {
  String cookie = "";

  for (String key in _cookies.keys) {
    if (cookie.isNotEmpty) cookie += ";";
    String cookiesKey = _cookies[key]!;
    cookie += key + "=" + cookiesKey;
  }

  return cookie;
}

Uri https(String authority, String unencodedPath,
    [Map<String, dynamic>? queryParameters]) {
  if (TESTING) {
    return Uri.http(authority, unencodedPath, queryParameters);
  } else {
    return Uri.https(authority, unencodedPath, queryParameters);
  }
}

void _setCookie(String rawCookie) {
  if (rawCookie.isNotEmpty) {
    var keyValue = rawCookie.split('=');
    if (keyValue.length == 2) {
      var key = keyValue[0].trim();
      var value = keyValue[1];

      // ignore keys that aren't cookies
      if (key == 'path' || key == 'expires') return;

      _cookies[key] = value;
    }
  }
}

void updateCookie(http.Response response) {
  String allSetCookie = response.headers['set-cookie'] ?? "";
  var setCookies = allSetCookie.split(',');
  for (var setCookie in setCookies) {
    var cookies = setCookie.split(';');

    for (var cookie in cookies) {
      _setCookie(cookie);
    }
  }
}

void setCookies(String cookiesToSet) {
  _cookies = {};
  var setCookies = cookiesToSet.split(',');
  for (var setCookie in setCookies) {
    var cookies = setCookie.split(';');

    for (var cookie in cookies) {
      _setCookie(cookie);
    }
  }
}
