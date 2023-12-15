import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meditate_app/util/logger.dart';

/// CookieController manages the logic for storing the user cookies. 🍪
/// {@category Controllers}
class CookieController extends GetxController {
  final storage = GetStorage();
  String cookiesKey = "cookies";

  Future<void> saveCookies(String cookies) async {
    logInfo("Saving cookies: $cookies -> $cookiesKey");
    storage.write(cookiesKey, cookies);
  }

  String getCookies() {
    return storage.read(cookiesKey) ?? "";
  }

  Future<void> clearCookies() async {
    storage.remove(cookiesKey);
  }
}
