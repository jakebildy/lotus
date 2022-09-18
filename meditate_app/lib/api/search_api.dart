import 'dart:convert';

import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as Api;

class SearchApi {
  static var _singleton;
  String get url => Api.url;
  SearchApi._internal();

  factory SearchApi() {
    if (_singleton == null) {
      _singleton = SearchApi._internal();
    }
    return _singleton;
  }

  //Endpoints

  Future<List<User>> searchStylists(String query) async {
    final response = await http.get(Api.https(url, "/api/user/search/${query}"),
        headers: Api.headers);
    if (response.statusCode == 200) {
      return User.listFromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }
}
