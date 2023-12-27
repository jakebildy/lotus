import 'dart:convert';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as api;

class PicturesApi {
  static PicturesApi? _singleton;
  String get url => api.url;
  PicturesApi._internal();

  factory PicturesApi() {
    _singleton ??= PicturesApi._internal();
    return _singleton!;
  }

  //Endpoints

  //File name must inlcude extension type i.e ".png or .jpg ect".
  Future<User> setProfilePicture(String fileName, String base64) async {
    final Map<String, String> map = {"fileName": fileName, "base64": base64};

    final String body = jsonEncode(map);
    final response = await http.post(api.https(url, "/api/user/upload-avatar"),
        body: body, headers: api.headers);
    if (response.statusCode == 200) {
      api.updateCookie(response);
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }
}
