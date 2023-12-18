import 'dart:convert';

import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as api;

class SearchApi {
  static var _singleton;
  String get url => api.url;
  SearchApi._internal();

  factory SearchApi() {
    _singleton ??= SearchApi._internal();
    return _singleton;
  }

  //Endpoints

  Future<List<User>> searchUsers(String query) async {
    final response = await http.get(api.https(url, "/api/user/search/${query}"),
        headers: api.headers);
    if (response.statusCode == 200) {
      return User.listFromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }
}
