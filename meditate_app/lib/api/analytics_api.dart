import 'dart:convert';

import 'package:http/http.dart' as http;
import "index.dart" as Api;

class AnalyticsApi {
  static var _singleton;
  String get url => Api.url;
  AnalyticsApi._internal();

  factory AnalyticsApi() {
    if (_singleton == null) {
      _singleton = AnalyticsApi._internal();
    }
    return _singleton;
  }

  //Endpoints
  Future<void> logUserEvent(String name) async {
    await http.post(Api.https(url, "/api/stats/log/$name"),
        headers: Api.headers);
  }
}
