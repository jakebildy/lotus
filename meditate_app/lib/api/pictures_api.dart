import 'dart:convert';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import "index.dart" as Api;

class PicturesApi {
  static var _singleton;
  String get url => Api.url;
  PicturesApi._internal();

  factory PicturesApi() {
    _singleton ??= PicturesApi._internal();
    return _singleton;
  }

  //Endpoints

  //File name must inlcude extension type i.e ".png or .jpg ect".
  Future<User> setProfilePicture(String fileName, String base64) async {
    final Map<String, String> map = {"fileName": fileName, "base64": base64};

    final String body = jsonEncode(map);
    final response = await http.post(Api.https(url, "/api/user/upload-avatar"),
        body: body, headers: Api.headers);
    if (response.statusCode == 200) {
      Api.updateCookie(response);
      return User.fromJson(json.decode(response.body));
    } else {
      throw (response.body);
    }
  }
}
