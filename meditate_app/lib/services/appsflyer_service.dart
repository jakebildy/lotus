import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

class AppsflyerService extends GetxService {
  AppsflyerService() {
    if (Platform.isIOS) {
      print("Initializing AppsFlyer...");
      _init();
    } else {
      print("Not on iOS, not initializing AppsFlyer");
    }
  }

  late AppsflyerSdk appsflyerSdk;

  void _init() async {
    AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
        afDevKey: "fDKWbmY89i8DNTKtDoHr5F",
        appId: "1645214014",
        showDebug: true,
        timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
        //appInviteOneLink: oneLinkID, // Optional field
        disableAdvertisingIdentifier: false, // Optional field
        disableCollectASA: false); // Optional field

    appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
  }

  Future<bool?> logEvent(String eventName, Map? eventValues) async {
    if (Platform.isIOS) {
      bool? result;
      try {
        result = await appsflyerSdk.logEvent(eventName, eventValues);
      } on Exception catch (e) {}
      print("Result logEvent: $result");
    } else {
      print("Can't log events on platforms other than iOS!");
    }
  }
}
