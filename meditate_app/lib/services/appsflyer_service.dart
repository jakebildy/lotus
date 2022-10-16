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

  void _init() async {
    AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
        afDevKey: "fDKWbmY89i8DNTKtDoHr5F",
        appId: "1645214014",
        showDebug: true,
        timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
        //appInviteOneLink: oneLinkID, // Optional field
        disableAdvertisingIdentifier: false, // Optional field
        disableCollectASA: false); // Optional field

    AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
  }
}
